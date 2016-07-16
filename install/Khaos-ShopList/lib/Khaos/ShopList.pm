package Khaos::ShopList;
use Dancer2;

our $VERSION = '0.1';

use Data::Dumper;
use Dancer2::Plugin::Database;

sub SHOW_ALL {"all"};
sub SHOWN    {"shown"};
sub HIDDEN   {"hidden"};

get '/' => sub {
    template 'index.tt';
};

## Lists
get '/lists'      => sub {

    my $list_row = get_max_id_row_table("lists");
    if ( $list_row->{id} ) {
        return redirect uri_for('/edit_shopping_list/'.$list_row->{id});
    }

    template 'lists.tt', {
        lists => get_table('lists','create_date DESC'),
    }
};

get '/edit_list/:list_id' => sub {
    template 'edit_list.tt', {
        edit_list => get_table_by_field('lists', 'id', params->{list_id})->[0],
        lists     => get_table('lists','create_date DESC'),
        list_id   => params->{list_id},
    }
};

post '/edit_list' => sub {
    eval { edit_list({ params() }) };
    if ( $@ ) {
        warn $@."\n";

        my $return_params = { error_msg => $@, };
        return redirect uri_for('/edit_list/'.params()->{list_id}, $return_params);
    }
    redirect uri_for('/lists');
};

get '/edit_shopping_list/:list_id' => sub {
    template 'edit_shopping_list.tt', {
        lists         => get_table('lists','create_date DESC'),
        list_id       => params->{list_id},
        shopping_list =>
            get_items_n_shops_ordered(undef,params->{list_id}),
    }
};

get '/view_shopping_list_text/:list_id' => sub {
    header 'Content-Type' => 'application/text';
    template 'shopping_list_text_justify.tt', {
        lists         => get_table('lists','create_date DESC'),
        list_id       => params->{list_id},
        shopping_list =>
            get_items_n_shops_ordered(undef,params->{list_id}, true),
    }, { layout => undef };
};

post '/edit_shopping_list_item/:list_id/:item_id/:plus_minus_action' => sub {

    my $quantity;
    eval{ $quantity = plus_minus_shopping_list_item({ params() }) };
    if ( $@ ) {
        warn $@."\n";

        status 'bad_request'; # TODO might be internal error.
        return;
    }

    status 'OK';
    return to_json { quantity => $quantity, item_id => param("item_id") };

};

sub plus_minus_shopping_list_item {
    my ($data) = @_;

    my $sql = "select * from shopping_lists where list_id = ? and item_id = ? ";

    my $sth = database->prepare($sql);
    $sth->execute($data->{list_id}, $data->{item_id});

    my $results ;
    while ( my $row = $sth->fetchrow_hashref ){
        # TODO a constraint on shopping_lists making list_id, item_id combo unique.
        die "more than one record returned for shopping list list_id=$data->{list_id}, item_id = $data->{item_id}" if $results;
        $results = $row;
    }

    my $change_quantity = sub {
        my ($quantity) = @_;
        $data->{plus_minus_action}= lc($data->{plus_minus_action});
        if ( $data->{plus_minus_action} eq 'plus' ) {
            $quantity++;
        } elsif ( $data->{plus_minus_action} eq 'minus' ) {
            $quantity--;
            $quantity = 0 if $quantity < 0;
        } else {
            die "Unrecognised plus_minus_action of '$data->{plus_minus_action}'"
        }
        return $quantity;
    };

    if ( defined $results ) {
        my $quantity = $change_quantity->( $results->{quantity} );

        my $sql =<<"        EOSQL";
            update shopping_lists set
                quantity = ?
            where id = ?
        EOSQL

        my $sth = database->prepare($sql);
        my $rv = $sth->execute(
            $quantity,
            $results->{id},
        );

        return $quantity;

    } else {
        my $quantity = $change_quantity->( 0 );

        my $sql =<<"        EOSQL";
            insert into shopping_lists
            (item_id,list_id,priority,quantity)
            VALUES ( ?,?,?,? )
        EOSQL

        my $sth = database->prepare($sql);
        my $rv = $sth->execute(
            $data->{item_id},
            $data->{list_id},
            0,
            $quantity,
        );

        return $quantity;
    }
}

sub edit_list {
    my ($data) = @_;

    die "need to supply a list id" if ! $data->{list_id};
    my $list_id = $data->{list_id};

    my $sql =<<"    EOSQL";
        update lists set
            name = ?,
            show_all_items = ?
        where id = ?
    EOSQL

    my $sth = database->prepare($sql);
    my $rv = $sth->execute(
        $data->{name},
        $data->{show_all_items} ? 'true' : 'false',
        $list_id,
    );
}

get '/add_list' => sub {

    return template 'add_list.tt',
    {
        lists => get_table('lists','create_date DESC'),
        error_msg   => param('error_msg'),
    };
};

post '/add_list' => sub {

    eval { add_list({ params() }) };
    if ( $@ ) {
        warn $@."\n";
        my $return_params = { error_msg => $@, };
        return redirect uri_for('/add_list', $return_params);
    }

    return redirect uri_for('/lists');

};

sub add_list {
    my ($data) = @_;

    my $sql =<<"    EOSQL";
        insert into lists
        ( name, show_all_items )
        values ( ?, ? )
    EOSQL

    my $sth = database->prepare($sql);
    my $rv = $sth->execute(
        $data->{name},
        $data->{show_all_items} ? 'true' : 'false',
    );
}


##########################
# items
get '/items'      => sub { template 'items.tt' };
get '/add_item' => sub {

    template 'add_item.tt',
    {
        error_msg   => param('error_msg'),
        old_name    => param('old_name'),
        old_item_group => param('old_item_group'),
        old_show_item  => param('old_show_item'),
        shops       => get_table('shops','name'),
        item_groups => get_table('item_groups','name'),
    };
};

post '/add_item' => sub {

    my $return_params = {};

    eval { add_item({ params() }) };
    if ( $@ ) {
        warn $@."\n";

        $return_params = {
            error_msg => $@,
            old_name => param('name'),
            old_item_group => param('item_group'),
            old_show_item  => param('show_item'),
        };
    } else {
        $return_params = {
            old_item_group => param('item_group'),
        };
    }

    redirect uri_for('/add_item', $return_params);

};

get '/edit_item/:item_id' => sub {

    template 'edit_item.tt',
    {
        error_msg   => param('error_msg'),
        item  =>
            get_table_by_field('items'     , 'id'    , params->{item_id})->[0],
        item_shops =>
            get_table_by_field('item_shops','item_id', params->{item_id}),
        shops       => get_table('shops','name'),
        item_groups => get_table('item_groups','name'),

    };
};

post '/edit_item' => sub {

    eval { edit_item({ params() }) };
    if ( $@ ) {
        warn $@."\n";

        my $return_params = { error_msg => $@, };
        return redirect uri_for('/edit_item/'.params()->{item_id}, $return_params);
    }

    redirect uri_for('/list_all_items');

};

get '/list_shown_items' => sub {

    template 'list_all_items.tt', {
        title => "Shown Items",
        items => get_items_n_shops_ordered(SHOWN),
    };
};

get '/list_hidden_items' => sub {

    template 'list_all_items.tt', {
        title => "Hidden Items",
        items => get_items_n_shops_ordered(HIDDEN),
    };
};

get '/list_all_items' => sub {

    template 'list_all_items.tt', {
        title => "All Items",
        items => get_items_n_shops_ordered(SHOW_ALL),
    };
};

sub get_items_n_shops_ordered {
    my ($show_type, $shopping_list_id, $quant_gt_zero) = @_;

    # $show_type works viewing items (thus on the items.show_item field)
    # When viewing a shopping_list the $shopping_list_id is supplied,
    # so whether an shopping_list item is shown is dependent on the lists record for the shopping_list

    # $quant_gt_zero only works when $shopping_list_id is supplied.

    my $select = '';
    my $where  = '';
    my $from   = '';
    my @bind   = ();

    if ( ! $shopping_list_id ) {
        $where = 'where i.show_item is true'  if $show_type eq SHOWN();
        $where = 'where i.show_item is false' if $show_type eq HIDDEN();
    } else {

        $select = << "        EOSQL_1";
            ,( select quantity from shopping_lists as sl
                 where sl.item_id=i.id  and sl.list_id  = list.id)
                     as shopping_list_quantity

            ,( select priority from shopping_lists as sl2
                 where sl2.item_id=i.id and sl2.list_id = list.id)
                     as shopping_list_priority

            ,( select price    from shopping_lists as sl3
                 where sl3.item_id=i.id and sl3.list_id = list.id)
                     as shopping_list_price

            ,( select id       from shopping_lists as sl4
                 where sl4.item_id=i.id and sl4.list_id = list.id)
                     as shopping_list_id
            , list.id as list_id

        EOSQL_1

        $from = "left join lists as list on ( list.id = ? )";

        $where = << "        EOSQL_2";
        where
            (
                ( list.show_all_items = false and i.show_item = true )
                or list.show_all_items = true
            )
        EOSQL_2

        @bind = ( $shopping_list_id );
    }

    my $sql =<<"    EOSQL_3";
        select
            i.id as item_id,
            i.name as item_name,
            i.show_item,
            igs.id as item_group_id,
            igs.name as item_group_name,
            igs.tag  as item_group_tag,
            ishp.price as item_shop_price,
            s.name   as shop_name,
            s.tag    as shop_tag
            $select
        from items as i
            left join item_groups as igs  on (i.item_group_id = igs.id)
            left join item_shops  as ishp on (ishp.item_id = i.id )
            left join shops       as s    on (s.id = ishp.shop_id )
            $from

        $where

        order by igs.sequence, i.name, s.name

    EOSQL_3

    my $sth = database->prepare($sql);
    $sth->execute( @bind );

    my $current_item_name  = '';
    my $current_item_group_name = '';

    my $gen_item_shop = sub {
        my ($i_ar_last) = @_;

        $i_ar_last->{shops_n_name} = "(".join(',',@{$i_ar_last->{shops}}).") ".$i_ar_last->{name};
    };

    my $results = [];
    while ( my $row = $sth->fetchrow_hashref ){

        my %shopping_items = ();
        if ( $shopping_list_id ) {

            next if ! $row->{shopping_list_quantity} and $quant_gt_zero;

            %shopping_items = (
                shopping_list_quantity => $row->{shopping_list_quantity},
                shopping_list_priority => $row->{shopping_list_priority},
                shopping_list_price    => $row->{shopping_list_price},
                shopping_list_id       => $row->{shopping_list_id},
            );
        }

        if ( $current_item_group_name ne $row->{item_group_name} ){
            $current_item_group_name = $row->{item_group_name};
            push @$results, {
                item_group_name => $row->{item_group_name},
                items => []
            };
        }

        if ($current_item_name ne $row->{item_name}){
            $current_item_name = $row->{item_name};

            push @{$results->[$#$results]{items}}
                , { id    => $row->{item_id},
                    name  => $current_item_name,
                    shops => [ $row->{shop_tag}],
                    %shopping_items,
                  };

            my $i_ar = $results->[$#$results]{items};
            $gen_item_shop->($i_ar->[$#$i_ar]);

        } else {
            my $i_ar = $results->[$#$results]{items};
            push @{$i_ar->[$#$i_ar]{shops}}, $row->{shop_tag};
            $gen_item_shop->($i_ar->[$#$i_ar]);
        }
    }
    return $results;
}

sub _check_item_data {
    my ($data) = @_;
    die "need to supply an item name" if ! $data->{name};

    my $shops = [];
    if ( $data->{shops} ){
        if ( ref $data->{shops} ne 'ARRAY' ){
            push @$shops, $data->{shops};
        } else {
            push @$shops, @{$data->{shops}};
        }
    }

    die "need to specify which shops"
        if ! scalar @$shops;

    die "need to specify category"
        if ! $data->{item_group};

    return $shops;
}

sub add_item {
    my ($data) = @_;

    my $shops = _check_item_data($data);

    my $sql =<<"    EOSQL";
        insert into items
        ( name, item_group_id , show_item )
        values ( ?, ?, ? )
    EOSQL

    my $sth = database->prepare($sql);
    my $rv = $sth->execute(
        $data->{name},
        $data->{item_group},
        $data->{show_item} ? 'true' : 'false',
    );

    $sql = "select id from items where name = ? ";
    $sth = database->prepare($sql);
    $sth->execute($data->{name});

    my $item_id;
    while ( my $row = $sth->fetchrow_hashref ){
        die "more than one item returned. internal error"
            if $item_id; # should be a unique index on "name"

        $item_id = $row->{id};
    }

    die "Can't find $data->{name} in items table" if ! $item_id;

    for my $shop_id (@$shops){
        $sql =<<"        EOSQL";
            insert into item_shops
            ( item_id, shop_id )
            values ( ?, ? )
        EOSQL

        my $sth = database->prepare($sql);
        $sth->execute(
            $item_id,
            $shop_id,
        );
    }

}

sub edit_item {
    my ($data) = @_;

    die "need to supply an item name" if ! $data->{item_id};
    my $item_id = $data->{item_id};

    my $shops = _check_item_data($data);

    my $sql =<<"    EOSQL";
        update items set
            name = ?,
            item_group_id = ?,
            show_item = ?
        where id = ?
    EOSQL

    my $sth = database->prepare($sql);
    my $rv = $sth->execute(
        $data->{name},
        $data->{item_group},
        $data->{show_item} ? 'true' : 'false',
        $item_id,
    );

    $sql ="delete from item_shops where item_id = ?";
    $sth = database->prepare($sql);
    $rv = $sth->execute(
        $item_id,
    );

    for my $shop_id (@$shops){
        $sql =<<"        EOSQL";
            insert into item_shops
            ( item_id, shop_id )
            values ( ?, ? )
        EOSQL

        my $sth = database->prepare($sql);
        $sth->execute(
            $item_id,
            $shop_id,
        );
    }
}

# shops
get '/shops'      => sub {

    return template 'not_yet_implemented';

    # template 'shops.tt';
};

# categories
get '/categories' => sub { template 'categories.tt' };

get '/list_categories' => sub {
    return template 'list_categories.tt', {
        categories => get_table('item_groups', 'sequence'),
        error_msg  => param('error_msg'),
    };
};

get '/add_category' => sub {
    return template 'add_category.tt', {
        error_msg => param('error_msg'),
        name      => param('name'),
        tag       => param('tag'),
        sequence  => param('sequence'),
    };
};

post '/add_category' => sub {

    eval { add_category({ params() }) };
    if ( $@ ) {
        warn $@."\n";
        my $return_params = {
            error_msg => $@,
            name      => param("name"),
            tag       => param("tag"),
            sequence  => param("sequence"),
        };

        return redirect uri_for('/add_category', $return_params);
    }

    return redirect uri_for('/add_category');
};

sub add_category {
    my ($data) = @_;

    my $sql =<<"    EOSQL";
        insert into item_groups
        ( name, tag, sequence )
        values ( ?, ?, ? )
    EOSQL

    my $sth = database->prepare($sql);
    my $rv = $sth->execute(
        $data->{name},
        $data->{tag},
        $data->{sequence},
    );
}

get '/edit_category/:id' => sub {

    my $category_row = get_table_by_field('item_groups','id',params->{id})->[0];

    warn "category row = ". Dumper($category_row);

    return template 'edit_category.tt', {
        error_msg    => param('error_msg'),
        category     => $category_row,
    };
};

post '/edit_category' => sub {

    eval { edit_category({ params() }) };
    if ( $@ ) {
        warn $@."\n";
        my $return_params = { error_msg => $@, };
        return redirect uri_for('/edit_category/'.param('id'), $return_params);
    }

    return redirect uri_for('/list_categories');
};

sub edit_category {
    my ($data) = @_;

    die "need to supply a category id" if ! $data->{id};

    my $sql =<<"    EOSQL";
        update item_groups set
            name = ?,
            tag  = ?,
            sequence = ?
        where id = ?
    EOSQL

    my $sth = database->prepare($sql);
    my $rv = $sth->execute(
        $data->{name},
        $data->{tag},
        $data->{sequence},
        $data->{id},
    );
}

#################
# db general subs
#################
sub get_table_by_field {
    my ($table, $field, $value) = @_;

    my $sql = " select * from $table where $field = ?";

    my $sth = database->prepare($sql);
    $sth->execute($value);

    my $results = [];
    while ( my $row = $sth->fetchrow_hashref ){
        push @$results, $row;
    }
    return $results;
}

sub get_max_id_row_table {
    my ($table) = @_;

    my $sql = "select * from $table where id in ( select max(id) from $table )";

    my $sth = database->prepare($sql);
    $sth->execute();

    my $results = [];
    while ( my $row = $sth->fetchrow_hashref ){
        return $row;
    }
    return {};
}

sub get_table {
    my ($table, $order_by) = @_;

    my $sql = " select * from $table order by $order_by";

    my $sth = database->prepare($sql);
    $sth->execute();

    my $results = [];
    while ( my $row = $sth->fetchrow_hashref ){
        push @$results, $row;
    }

    return $results;
}

true;
