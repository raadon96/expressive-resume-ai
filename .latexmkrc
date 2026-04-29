# Set to 1 to delete build artifacts after each successful build (keeps PDF).
# Set to 0 to keep artifacts (enables faster incremental rebuilds).
our $cleanup_after_build = 1;

$success_cmd = 'internal cleanup_build_artifacts';

sub cleanup_build_artifacts {
    return unless $cleanup_after_build;
    (my $base = $root_filename) =~ s/\.tex$//;
    my @exts = qw(aux fdb_latexmk fls log out synctex.gz);
    for my $ext (@exts) {
        my $file = "$base.$ext";
        unlink $file if -e $file;
    }
}
