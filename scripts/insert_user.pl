use VK;
use Data::Dumper;
use Data::Dumper::AutoEncode;
use DBI;
use DBI::Log;
use DBD::MariaDB;
use feature 'say';

my $dsn = "DBI:MariaDB:database=".$ENV{'DATABASE'}.";host=".$ENV{'DB_HOST'}.";port=".$ENV{'DB_PORT'};
say "DSN: ".$dsn;
say "DB User: ".$ENV{'DB_USER'};
say "DB password: ".$ENV{'DB_PASSWORD'};
my $dbh = DBI->connect( $dsn, $ENV{'DB_USER'}, $ENV{'DB_PASSWORD'} );

sub insert_user {
  my $row = shift;
  $row->{sex} = 'f' if ( $row->{sex} == 1 );
  $row->{sex} = 'm' if ( $row->{sex} == 2 );
  $dbh->do(
    qq/
      INSERT
        INTO users
        (vk_id, bdate, age, sex, city, faculty, cathedra, vk_interests, status, vk_all_group_names, vk_all_posts, vk_all_group_descr)
        VALUES
        (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    /,
    undef,
    $row->{id}, $row->{bdate}, $row->{age}, $row->{sex}, $row->{city}{title}, $row->{name}, '', $row->{interests}, $row->{status}, '', '', '' );
   print "User inserted";
}

my $vk = VK->new;
my $res = $vk->query( 'users.get', {
    user_id => $ARGV[0] || 4485606,  # Оля: 2606187,
    extended => 1,
    fields => $ENV{'USER_GET_FIELDS'}
} );

warn eDumper $res;

insert_user($res->{response}->[0]);
