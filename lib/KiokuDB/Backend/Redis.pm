package KiokuDB::Backend::Redis;
use Moose;

use Redis;

our $VERSION = '0.01';

has '_redis' => (
    is => 'ro',
    isa => 'Redis',
    lazy => 1,
    default => sub {
        Redis->new(server => '127.0.0.1:6379', debug => 0)
    }
);

with qw(
    KiokuDB::Backend
    KiokuDB::Backend::Serialize::Delegate
);

sub delete {
    my ($self, @ids_or_entries) = @_;

    my $redis = $self->_redis;

    my @uids = map { ref($_) ? $_->id : $_ } @ids_or_entries;

    foreach my $id ( @uids ) {

        $redis->del($id);
    }

    return;
}

sub exists {
    my ($self, @ids) = @_;

    my @exists;

    my $redis = $self->_redis;
    foreach my $id (@ids) {

        if($redis->exists($id)) {
            push(@exists, 1);
        } else {
            push(@exists, 0);
        }
    }

    return @exists;
}

sub insert {
    my ($self, @entries) = @_;

    my $redis = $self->_redis;

    foreach my $entry ( @entries ) {
        my $ret = $redis->set(
            $entry->id => $self->serialize($entry),
        );
    }
}

sub get {
    my ($self, @ids) = @_;

    my ( $var, @ret );

    my $redis = $self->_redis;

    foreach my $id ( @ids ) {
        my $val = $redis->get($id);
        if(defined($val)) {
            push @ret, $val;
        } else {
            return;
        }
    }

    return map { $self->deserialize($_) } @ret;
}

1;

__END__

=head1 NAME

KiokuDB::Backend::Redis - Redis backend for KiokuDB

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use KiokuDB::Backend::Redis;

    my $foo = KiokuDB::Backend::Redis->new();
    ...

=head1 AUTHOR

Cory G Watson, C<< <gphat at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-kiokudb-backend-redis at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=KiokuDB-Backend-Redis>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc KiokuDB::Backend::Redis


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=KiokuDB-Backend-Redis>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/KiokuDB-Backend-Redis>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/KiokuDB-Backend-Redis>

=item * Search CPAN

L<http://search.cpan.org/dist/KiokuDB-Backend-Redis/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Cory G Watson.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of KiokuDB::Backend::Redis
