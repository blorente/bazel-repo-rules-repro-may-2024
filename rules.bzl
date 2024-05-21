def _file_exists(rctx, path):
    return rctx.execute(["test", "-f", path]).return_code == 0

def _counter_impl(rctx):
    print("Running counter")
    marker_file_path = "/tmp/manual_counter"
    file_writer = str(rctx.path(rctx.attr._file_writer))
    if not _file_exists(rctx, marker_file_path):
        rctx.execute([file_writer, "0", marker_file_path])

    marker_contents = int(rctx.read(marker_file_path).strip()) + 1
    print("Writing counter value {}".format(marker_contents))
    rctx.execute([file_writer, str(marker_contents), marker_file_path])
    rctx.file("BUILD.bazel", "filegroup(name = 'files', srcs = [])")

counter_repo_rule = repository_rule(
    implementation = _counter_impl,
    configure = True,
    local = True,
    attrs = {
        "_file_writer": attr.label(
            doc = "Path to a utility that can write files from arbitrary paths in the filesystem. It should expose the interface ./utility '<data>' '<destination>'",
            allow_single_file = True,
            cfg = "exec",
            executable = True,
            default = "//:write_to_file.sh",
        ),
    },
)

