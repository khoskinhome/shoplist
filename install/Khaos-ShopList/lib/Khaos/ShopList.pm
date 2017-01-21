package Khaos::ShopList;
use Dancer2;

use POSIX qw(strftime);
our $VERSION = '0.1';

use Data::Dumper;
use Dancer2::Plugin::Database;
use Dancer2::Session::Memcached;


sub SHOW_ALL {"all"}
sub SHOWN    {"shown"}
sub HIDDEN   {"hidden"}

sub ALL_CATEGORY_ID {-1}

# TODO implement different types of category sorting.
sub CATEGORY_ORDER_ALPHA_ASC {'alpha-asc'}
sub CATEGORY_ORDER_ALPHA_DESC {'alpha-desc'}
sub CATEGORY_ORDER_SEQUENCE_ASC {'sequence-asc'}
sub CATEGORY_ORDER_SEQUENCE_DESC {'sequence-desc'}

get '/' => sub {
    if (param('c')){ session 'disp_col' =>  (param('c')) }

    template 'index.tt';
};

## Lists
get '/lists'      => sub {
    if (param('c')){ session 'disp_col' =>  (param('c')) }

    my $list_row = get_max_id_row_table("lists");
    if ( $list_row->{id} ) {
        return redirect uri_for('/edit_shopping_list/'.$list_row->{id});
    }

    template 'lists.tt', {
        _lists_n_categories_for_tt({params()}),
    }
};

get '/edit_list/:list_id' => sub {
    if (param('c')){ session 'disp_col' =>  (param('c')) }

    template 'edit_list.tt', {
        edit_list   => get_table_by_field('lists', 'id', params->{list_id})->[0],
        _lists_n_categories_for_tt({params()}),
    }
};

post '/edit_list' => sub {
    eval { edit_list({ params() }) };
    if ( $@ ) {
        warn $@."\n";

        my $return_params = {
            error_msg   => $@,
            category_id => params->{category_id},
        };
        return redirect uri_for('/edit_list/'.params()->{list_id}, $return_params);
    }
    redirect uri_for('/lists');
};

get '/edit_shopping_list/:list_id' => sub {
    if (param('c')){ session 'disp_col' =>  (param('c')) }
    template 'edit_shopping_list.tt', {
        shopping_list_name => _get_shopping_list_name({params()}),
        _lists_n_categories_for_tt({params()}),
        shopping_list =>
            get_items_n_shops_ordered(undef,params->{list_id}, undef, params->{category_id}),
    }
};

get '/view_shopping_list_text/:list_id' => sub {
    if (param('c')){ session 'disp_col' =>  (param('c')) }
    header 'Content-Type' => 'application/text';
    template 'shopping_list_text_justify.tt', {
        shopping_list_name => _get_shopping_list_name({params()}),
        _lists_n_categories_for_tt({params()}),
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
        } elsif ( $data->{plus_minus_action} eq 'delete' ) {
            $quantity = 0 ;
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
    if (param('c')){ session 'disp_col' =>  (param('c')) }

    return template 'add_list.tt',
    {
        _lists_n_categories_for_tt({params()}),
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

sub _get_shopping_list_name {
    my ($p_params) = @_;
    my $row = get_table_by_field('lists','id',$p_params->{list_id})->[0];

    return $row->{name}._generated_tstmp() if $row;
    return _generated_tstmp();
}

sub _generated_tstmp {
    return " ( Generated : ". strftime('%F %T', localtime())." )";
}

sub _lists_n_categories_for_tt {
    my ($p_params) = @_;

    my @categories = (
        {ALL_CATEGORY_ID => -1, name => 'All', tag => 'all', sequence => 0},
        @{get_table('item_groups','sequence ASC')}
    );
    my $category_id = $p_params->{category_id};

    $category_id = ALL_CATEGORY_ID if ! $category_id;

    return (
        lists       => get_table('lists','create_date DESC'),
        list_id     => $p_params->{list_id},
        categories  => \@categories,
        category_id => $category_id,
        _disp_col(),
    );

}

##########################
# items
get '/items'      => sub {
    if (param('c')){ session 'disp_col' =>  (param('c')) }
    template 'items.tt';
};
get '/add_item' => sub {

    if (param('c')){ session 'disp_col' =>  (param('c')) }
    template 'add_item.tt',
    {
        error_msg   => param('error_msg'),
        old_name    => param('old_name'),
        old_item_group => param('old_item_group'),
        old_show_item  => param('old_show_item'),
        shops       => get_table('shops','name'),
        item_groups => get_table('item_groups','name'),
        _disp_col(),
    };
};

sub _disp_col {

    my $disp_col = ((session('disp_col') * 1) || 3);

    $disp_col = 1 if is_mobile_browser();

    return (
        disp_col  => $disp_col,
        is_mobile => is_mobile_browser(),
    );
}

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

    if (param('c')){ session 'disp_col' =>  (param('c')) }
    template 'edit_item.tt',
    {
        error_msg   => param('error_msg'),
        item  =>
            get_table_by_field('items'     , 'id'    , params->{item_id})->[0],
        item_shops =>
            get_table_by_field('item_shops','item_id', params->{item_id}),
        shops       => get_table('shops','name'),
        item_groups => get_table('item_groups','name'),
        _disp_col(),

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

    if (param('c')){ session 'disp_col' =>  (param('c')) }
    template 'list_all_items.tt', {
        title => "Shown Items",
        items => get_items_n_shops_ordered(SHOWN),
        _disp_col(),
    };
};

get '/list_hidden_items' => sub {

    if (param('c')){ session 'disp_col' =>  (param('c')) }
    template 'list_all_items.tt', {
        title => "Hidden Items",
        items => get_items_n_shops_ordered(HIDDEN),
        _disp_col(),
    };
};

get '/list_all_items' => sub {

    if (param('c')){ session 'disp_col' =>  (param('c')) }
    template 'list_all_items.tt', {
        title => "All Items",
        items => get_items_n_shops_ordered(SHOW_ALL),
        _disp_col(),
    };
};

sub get_items_n_shops_ordered {
    my ($show_type, $shopping_list_id, $quant_gt_zero, $category_id) = @_;

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

    if ( defined $category_id && $category_id >= 1 ){
        if( ! $where ){
            $where  = " where igs.id ? ";
        } else {
            $where .= " and igs.id = ? ";
        }
        push @bind, $category_id;
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

    if (param('c')){ session 'disp_col' =>  (param('c')) }
    return template 'not_yet_implemented',{
        _disp_col(),
    };

    # template 'shops.tt';
};

# categories
get '/categories' => sub {
    if (param('c')){ session 'disp_col' =>  (param('c')) }
    template 'categories.tt', {
        _disp_col(),
    };
};

get '/list_categories' => sub {
    if (param('c')){ session 'disp_col' =>  (param('c')) }
    return template 'list_categories.tt', {
        categories => get_table('item_groups', 'sequence'),
        error_msg  => param('error_msg'),
        _disp_col(),
    };
};

get '/add_category' => sub {
    if (param('c')){ session 'disp_col' =>  (param('c')) }
    return template 'add_category.tt', {
        error_msg => param('error_msg'),
        name      => param('name'),
        tag       => param('tag'),
        sequence  => param('sequence'),
        _disp_col(),
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

    if (param('c')){ session 'disp_col' =>  (param('c')) }
    my $category_row = get_table_by_field('item_groups','id',params->{id})->[0];

    warn "category row = ". Dumper($category_row);

    return template 'edit_category.tt', {
        error_msg    => param('error_msg'),
        category     => $category_row,
        _disp_col(),
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


sub is_mobile_browser {

    warn request->user_agent;

    if ( request->user_agent =~ m/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i
        || substr(request->user_agent, 0, 4) =~ m/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v)|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i) {

        return 1;
    }
    return 0;
}

true;
