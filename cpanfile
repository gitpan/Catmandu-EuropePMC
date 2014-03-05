requires 'perl', 'v5.10.1';

on test => sub {
    requires 'Test::More', '0.88';
    requires 'Test::Exception', '0.32';
};

requires 'Catmandu', '>=0.8002';
requires 'LWP::UserAgent', '>= 6.0';
requires 'XML::Simple', '>= 2.2';
requires 'Try::Tiny', '0.12';
