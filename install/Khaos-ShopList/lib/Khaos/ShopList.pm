package Khaos::ShopList;
use Dancer2;

our $VERSION = '0.1';

use Data::Dumper;
use Dancer2::Plugin::Database;

get '/' => sub {
    template 'index.tt';
};

## Lists
get '/lists'      => sub {

    template 'lists.tt', {
        lists => get_table('lists','create_date DESC'),
    }

};

get '/lists_action' => sub {

    if ( param('edit_list')){
        template 'edit_list.tt', {
            edit_list => get_table_by_field('lists', 'id', params->{list_id})->[0],
            lists => get_table('lists','create_date DESC'),
        }
    } elsif ( param('edit_list_items') ){

        template 'edit_list_items.tt', {
            lists => get_table('lists','create_date DESC'),
        }
    }

};

#get '/edit_list' => sub {
#    template 'edit_list.tt';
#};

post '/edit_list' => sub {

    warn "POST PARAMS \n".Dumper (params());

    eval { edit_list({ params() }) };
    if ( $@ ) {
        warn $@."\n";

        my $return_params = { error_msg => $@, };
        return redirect uri_for('/edit_list/'.params()->{list_id}, $return_params);
    }

    redirect uri_for('/lists');
};

sub edit_list {
    my ($data) = @_;

    die "need to supply a list id" if ! $data->{list_id};
    my $list_id = $data->{list_id};

    my $sql =<<"    EOSQL";
        update lists set
            name = ?,
            show_all_items = ?,
            show_list = ?
        where id = ?
    EOSQL

    my $sth = database->prepare($sql);
    my $rv = $sth->execute(
        $data->{name},
        $data->{show_all_items} ? 'true' : 'false',
        $data->{show_list} ? 'true' : 'false',
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
        ( name, show_list , show_all_items )
        values ( ?, ?, ? )
    EOSQL

    my $sth = database->prepare($sql);
    my $rv = $sth->execute(
        $data->{name},
        $data->{show_list} ? 'true' : 'false',
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

    warn "POST return params \n".Dumper($return_params);
    redirect uri_for('/add_item', $return_params);

};

get '/edit_item/:item_id' => sub {

    warn "EDIT ITEM\n".Dumper(
            get_table_by_field('item_shops','item_id', params->{item_id}),
    );

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

    warn "POST PARAMS \n".Dumper (params());

    eval { edit_item({ params() }) };
    if ( $@ ) {
        warn $@."\n";

        my $return_params = { error_msg => $@, };
        return redirect uri_for('/edit_item/'.params()->{item_id}, $return_params);
    }

    redirect uri_for('/list_all_items');

};

get '/list_shown_items' => sub {

    #warn Dumper ( get_items_n_shops_ordered());
    template 'list_all_items.tt', {
        items => get_items_n_shops_ordered(),
    };
};

get '/list_all_items' => sub {

    #warn Dumper ( get_items_n_shops_ordered(true));
    template 'list_all_items.tt', {
        items => get_items_n_shops_ordered(true),
    };
};

sub get_items_n_shops_ordered {
    my ($show_all) = @_;

    my $where = '';
    $where = 'where i.show_item is true' if ! $show_all;

    my $sql =<<"    EOSQL";
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
        from items as i
            left join item_groups as igs  on (i.item_group_id = igs.id)
            left join item_shops  as ishp on (ishp.item_id = i.id )
            left join shops       as s    on (s.id = ishp.shop_id )
        $where

        order by igs.sequence, i.name, s.name

    EOSQL

    my $sth = database->prepare($sql);
    $sth->execute();

    my $results = [];

    my $current_item_name  = '';
    my $current_item_group_name = '';

    my $gen_item_shop = sub {
        my ($i_ar_last) = @_;

        $i_ar_last->{shops_n_name} = "(".join(',',@{$i_ar_last->{shops}}).") ".$i_ar_last->{name};
    };

    while ( my $row = $sth->fetchrow_hashref ){
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
get '/shops'      => sub { template 'shops.tt' };

# categories
get '/categories' => sub { template 'categories.tt' };

sub get_table_by_field {
    my ($table, $field, $id) = @_;

    my $sql = " select * from $table where $field = ?";

    my $sth = database->prepare($sql);
    $sth->execute($id);

    my $results = [];
    while ( my $row = $sth->fetchrow_hashref ){
        push @$results, $row;
    }
    return $results;
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
