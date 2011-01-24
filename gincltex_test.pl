#!/usr/bin/perl 
use strict;
use warnings;

srand (time ^ $$ ^ unpack "%L*", `ps axww | gzip -f`);

my %ARGS = (
    height => sub { sprintf "%gpt", 50+rand(250)},
    width  => sub { sprintf "%gpt", 50+rand(250) },
    totalheight => sub { sprintf "%gpt", 50+rand(250) },
    angle  => sub { sprintf "%g", rand(360) },
);

my $num;

my @ARGS = keys %ARGS;

my %combi;

for my $num (1 .. 100) {
    my %seen;
    my @args;
    my @argsstr;
    for (0 .. int(rand(@ARGS-1))) {
        my $arg;
        do {
            $arg = $ARGS[ int(rand(@ARGS)) ];
        } while (exists $seen{$arg});
        $seen{$arg} = 1;
        if ($arg eq 'height') { $seen{totalheight} = 1; }
        if ($arg eq 'totalheight') { $seen{height} = 1; }
        my $str = sprintf "%s=%s", $arg, $ARGS{$arg}();
        push @args, $arg;
        push @argsstr, $str;
    }
    #my $comb = join(',',@args);
    #redo if exists $combi{$comb};
    #$combi{$comb} = 1;
    print "% $num\n\\test {", join(',',@argsstr), "}\n\n";
}

