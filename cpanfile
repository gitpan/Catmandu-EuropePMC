requires 'perl', 'v5.10.1';

on test => sub {
    requires 'Test::More', '0.88';
    requires 'Test::Exception', '0.32';
};

requires 'Catmandu', '>=0.8014';
requires 'Furl', '3.02';
requires 'XML::LibXML::Simple', '0.93';
requires 'Try::Tiny', '0.12';
