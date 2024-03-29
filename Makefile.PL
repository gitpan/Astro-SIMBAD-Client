use 5.008;

use strict;
use warnings;

use lib qw{ inc };

use Astro::SIMBAD::Client::Meta;
use Astro::SIMBAD::Client::Recommend;
use Config;
use ExtUtils::MakeMaker qw{WriteMakefile prompt};
use Getopt::Std;

my %opt;
getopts('ny', \%opt) or die <<eod;
The only legal options are
  -n = answer all questions 'no'.
  -y = answer all questions 'yes'.
You may not assert both of these at once - it's too confusing.
eod

Astro::SIMBAD::Client::Recommend->recommend();

my (@exe_files, @clean_files);

print <<EOD;

The simbadc script is a simple wrapper for Astro::SIMBAD::Client, which
may be used interactively or as a Unix filter.

>>>> NOTICE <<<<\a\a\a

As of version 0.032_01 the simbadc script is installed by default. If
you do not wish it installed. run this script with the -n option. The -y
option is still accepted for backward compatibility.

EOD

if ( $opt{n} ) {
    print "Because you have asserted -n, simbadc will not be installed.\n";
} else {
    push @exe_files, 'simbadc';
}

if ($^O eq 'MSWin32') {
    @exe_files = map {"bin/$_"} @exe_files;
    foreach (@exe_files) {`pl2bat $_`}
    @clean_files = @exe_files = grep {-e $_} map {"$_.bat"} @exe_files;
} elsif ($^O eq 'VMS') {
    foreach my $fni (map {"[.bin]$_"} @exe_files) {
	my $fno = "$fni.com";
	open (my $fhi, '<', $fni) or die "Unable to open $fni: $!\n";
	open (my $fho, '>', $fno) or die "Unable to open $fno: $!\n";
	print $fho "$Config{startperl}\n";
	while (<$fhi>) {print $fho $_}
	close $fho;
	close $fhi;
    }
    @clean_files = @exe_files = map {"[.bin]$_.com"} @exe_files;
} else {
    @exe_files = map {"bin/$_"} @exe_files;
}

(my $mmv = ExtUtils::MakeMaker->VERSION) =~ s/_//g;

my $meta = Astro::SIMBAD::Client::Meta->new();

my %attr = (
    NAME => 'Astro::SIMBAD::Client',
    VERSION_FROM => 'lib/Astro/SIMBAD/Client.pm',
    PREREQ_PM => $meta->requires(),
    PL_FILES => {},	# Prevent old MakeMaker from running Build.PL
    EXE_FILES => \@exe_files,
    realclean => {FILES => join ' ', @clean_files},
    'dist' => {COMPRESS => 'gzip', SUFFIX => 'gz'},
    AUTHOR => 'Tom Wyant (wyant@cpan.org)',
    ABSTRACT => 'Fetch astronomical data from SIMBAD 4.',
);

$mmv >= 6.31 and $attr{LICENSE} = 'perl';

$mmv >= 6.4501 and $attr{META_ADD} = {
    no_index => {
	directory => [ qw{ inc t xt } ],
    },
};

$mmv >= 6.4501 and $attr{META_MERGE} = {
    resources => {
	bugtracker => 'https://rt.cpan.org/Public/Dist/Display.html?Name=Astro-SIMBAD-Client',
	license => 'http://dev.perl.org/licenses/',
    },
};

$mmv >= 6.4701 and $attr{MIN_PERL_VERSION} = $meta->requires_perl();

$mmv >= 6.5501
    and $attr{BUILD_REQUIRES} = $meta->build_requires()
    or $mmv >= 6.4501
    and $attr{META_MERGE}{build_requires} = $meta->build_requires();

WriteMakefile (%attr);

# ex: set textwidth=72 :
