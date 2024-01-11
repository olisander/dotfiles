def "nu-complete task" [] {
    task -s -l | lines
}

export extern "task" [
  task?: string@"nu-complete task"   # Command to run. Defaults to "task". 
  --color(-c) # Colored output. Enabled by default. Set flag to false or use NO_COLOR=1 to disable. (default true)
  --concurrency(-C): int # Limit number tasks to run concurrently.
  --dir(-d): string # Sets directory of execution.
  --dry(-n) # Compiles and prints tasks in the order that they would be run, without executing them.
  --exit-code(-x) # Pass-through the exit code of the task command.
  --experiments # Lists all the available experiments and whether or not they are enabled.
  --force(-f) # Forces execution even when the task is up-to-date.
  --global(-g) # Runs global Taskfile, from $HOME/{T,t}askfile.{yml,yaml}.
  --help(-h) # Shows Task usage.
  --init(-i) # Creates a new Taskfile.yml in the current folder.
  --insecure # Forces Task to download Taskfiles over insecure connections.
  --interval(-I): int # Interval to watch for changes.
  --json(-j) # Formats task list as JSON.
  --list(-l) # Lists tasks with description of current Taskfile.
  --list-all(-a) # Lists tasks with or without a description.
  --no-status # Ignore status when listing tasks as JSON
  --output(-o): string # Sets output style: [interleaved|group|prefixed].
  --output-group-begin: string # Message template to print before a task's grouped output.
  --output-group-end: string # Message template to print after a task's grouped output.
  --output-group-error-only # Swallow output from successful tasks.
  --parallel(-p) # Executes tasks provided on command line in parallel.
  --silent(-s) # Disables echoing.
  --sort: string # Changes the order of the tasks when listed. [default|alphanumeric|none].
  --status # Exits with non-zero exit code if any of the given tasks is not up-to-date.
  --summary # Show summary about a task.
  --taskfile(-t): string # Choose which Taskfile to run. Defaults to "Taskfile.yml".
  --verbose(-v) # Enables verbose mode.
  --version # Show Task version.
  --watch(-w) # Enables watch of the given task.
  --yes(-y) # Assume "yes" as answer to all prompts.
  --help(-h) # Shows Task usage.
] 
