package App::ParseCPANChanges;

use 5.010001;
use strict;
use warnings;

our $VERSION = '0.02'; # VERSION

our %SPEC;

$SPEC{parse_cpan_changes} = {
    v => 1.1,
    summary => 'Parse CPAN Changes file',
    args => {
	file => {
	    schema => 'str*',
	    summary => 'If not specified, will look for file called '.
		'Changes/ChangeLog in current directory',
	    pos => 0,
	},
    },
};
sub parse_cpan_changes {
    require CPAN::Changes;
    require Data::Structure::Util;

    my %args = @_;

    my $file = $args{file};
    if (!$file) {
	for (qw/Changes ChangeLog/) {
	    do { $file = $_; last } if -f $_;
	}
    }

    my $ch = CPAN::Changes->load($file);
    [200, "OK", Data::Structure::Util::unbless($ch)];
}

1;
# ABSTRACT: Parse CPAN Changes file

__END__

=pod

=encoding utf-8

=head1 NAME

App::ParseCPANChanges - Parse CPAN Changes file

=head1 VERSION

version 0.02

=head1 DESCRIPTION

This distribution provides a simple command-line wrapper for
L<CPAN::Changes>.

=head1 SEE ALSO

L<CPAN::Changes>

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 FUNCTIONS


None are exported by default, but they are exportable.

=head2 parse_cpan_changes(%args) -> [status, msg, result, meta]

Arguments ('*' denotes required arguments):

=over 4

=item * B<file> => I<str>

If not specified, will look for file called Changes/ChangeLog in current directory.

=back

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=cut
