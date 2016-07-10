package Khaos::ShopList;
use Dancer2;

our $VERSION = '0.1';

use Data::Dumper;
use Dancer2::Plugin::Database;


get '/' => sub {
    template 'index.tt';
};

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

#    warn "POST PARAMS \n".Dumper (params());

    my $return_params = {};

    eval { insert_item({ params() }) };
    if ( $@ ) {
        warn $@."\n";

        $return_params = {
            error_msg => $@,
            old_name => param('name'),
            old_item_group => param('item_group'),
            old_show_item  => param('show_item'),
        };
    }

    warn "POST return params \n".Dumper($return_params);
    redirect uri_for('/add_item', $return_params);

};

sub insert_item {
    my ($data) = @_;

    die "need to supply an item name" if ! $data->{name};

    my $shops = $data->{shops};
    $shops = [$shops] if ref $shops ne 'ARRAY';

    die "need to specify which shops"
        if ! scalar @$shops;

    die "need to specify category"
        if ! $data->{item_group};

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

get '/edit_item' => sub {
    template 'edit_item.tt';
};

get '/add_list' => sub {
    template 'add_list.tt';
};

get '/list_all_items' => sub {
    template 'list_all_items.tt';
};

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
