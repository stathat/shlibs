use HTTP::Request::Common qw(POST);
use LWP::UserAgent;

sub stathat_post {
        my ($path, $params) = @_;
        my $ua = LWP::UserAgent->new;
        my $req = POST 'http://api.stathat.com/' . $path, $params;
        return $ua->request($req)->as_string;
};

sub stathat_count {
        my ($stat_key, $user_key, $count) = @_;
        return stathat_post('c', [ key => $stat_key, ukey => $user_key, count => $count ]);
};

sub stathat_value {
        my ($stat_key, $user_key, $value) = @_;
        return stathat_post('v', [ key => $stat_key, ukey => $user_key, value => $value ]);
};

sub stathat_ez_count {
        my ($email, $stat_name, $count) = @_;
        return stathat_post('ez', [ email => $email, stat => $stat_name, count => $count ]);
};

sub stathat_ez_value {
        my ($email, $stat_name, $value) = @_;
        return stathat_post('ez', [ email => $email, stat => $stat_name, value => $value ]);
};

