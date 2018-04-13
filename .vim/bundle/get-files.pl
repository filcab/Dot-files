#!/usr/bin/env perl

use Cwd;

use strict;
use warnings;


our @types = qw/cvs svn curl tgz zip bzr_tgz git/;
our @support_update = qw/svn git bzr/;

open SOURCES, "<sources" or die $!;

our $update = 0;
my $not_update_message = 0;

if ($#::ARGV == 0) {
    $update = $::ARGV[0] eq "--update";
}

while (<SOURCES>) {
    next if /^\s*\#|^\s*$/;
    chomp;
    my ($dir, $type, @arguments) = split(/\|/, $_);
    print "$dir:$type:";

    if (not grep /$type/, @types) {
        print "Source type not recognized: $type\n";
        next;
    }

    if ($#ARGV < 0 or grep(/$dir/, @ARGV)) {
        if (not grep(/$type/, @support_update)) {
            print "not updating (yet)\n";
            $not_update_message = 1;
        }
        # Hack. Use dispatch table
        &{\&$type}($dir, @arguments);
    } elsif ($update) {
        if ($type eq "tgz" or $type eq "zip" or $type eq "curl") {
            print "skipped\n";
            next;
        }
        print "updating\n";
        # Hack. Use dispatch table
        &{\&$type}($dir, @arguments)
    } else { print "skipped\n"; }
}

if ($not_update_message) {
  print "To update the repos, run with --update";
}

sub cvs ($$$$) {
    my ($dir, $root, $module, $tag, $tagArg);
    $dir = shift, $root = shift, $module = shift, $tag = shift;

    if ($tag eq "") {
        $tagArg = "";
    } else {
        $tagArg = "-r$tag";
    }

    if ($update) {
        my $cmd = "cvs -d$root co $tagArg $module";
        print "$cmd\n";
        open CMD, "$cmd|";
        print while (<CMD>);

        return;
    }

    if (-e $dir) {
        my $old_dir = getcwd;
        # Maybe update

    } else {
        my $cmd = "cvs -d$root co $tagArg $module";
        print "$cmd\n";
        open CMD, "$cmd|";
        print while (<CMD>);
    }
}

sub svn ($$) {
    my ($dir, $repo);
    $dir = shift, $repo = shift;

    if (-e $dir or $update) {
        my $cmd = "svn update $dir";
        open CMD, "$cmd|";
        print while (<CMD>);

        return;
    }

    # Doesn't exist yet, checkout repo
    my $cmd = "svn checkout $repo $dir";
    open CMD, "$cmd|";
    print while (<CMD>);
}

sub curl($$) {
    my ($file, $url);
    $file = shift, $url = shift;

    return if (-e $file);

    system("mkdir -p `dirname $file`");
    open CURL, "curl -o '$file' '$url'|";
    print while (<CURL>);
}

sub tgz ($$$) {
    my ($dir, $url, $res);
    $dir = shift, $url = shift, $res = shift;

    return if (-e $dir);

    print "Downloading from: $url\n";
    open CURL, "curl '$url' | tar xvzf -|";
    print while (<CURL>);
    `mv "$res" "$dir"` unless ($res eq "");
}

sub zip ($$$) {
    my ($dir, $url, $res);
    $dir = shift, $url = shift, $res = shift;

    return if (-e $dir);

    my $tmpf = "tmp.zip";
    print "Downloading from: $url\n";
    open CURL, "curl '$url' -o $tmpf|";
    print while (<CURL>);
    open UNZIP, "unzip $tmpf|";
    print while (<UNZIP>);
    `rm $tmpf`;
    `mv "$res" "$dir"` unless ($res eq "");
}

sub bzr_tgz ($$$$) {
    my ($dir, $bzr_url, $tgz_url, $res);
    $dir = shift, $bzr_url = shift, $tgz_url = shift, $res = shift;

    if (-e $dir or $update) {
        my $cmd = "bzr update $dir";
        open CMD, "$cmd|";
        print while (<CMD>);

        return;
    }

    # Doesn't exist yet, get repo
    open BZR, "bzr get $bzr_url $dir |";
    print while (<BZR>);
    close BZR;
    unless ($? == 0) {
        system("rm -rf $dir");
        tgz($dir, $tgz_url, $res);
    }
}

sub git ($$$$) {
    my ($dir, $git_url);
    $dir = shift, $git_url = shift;

    if (-e $dir or $update) {
        open GIT, "git -C '$dir' pull |";
        print while (<GIT>);
        close GIT;

        return;
    }

    # Doesn't exist yet, clone repo
    open GIT, "git clone $git_url $dir |";
    print while (<GIT>);
    close GIT;
}

print "\n";
print "Done!\n";

