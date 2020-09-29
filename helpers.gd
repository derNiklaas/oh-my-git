extends Node

var debug_file_io = false

# Crash the game and display the error message.
func crash(message):
	push_error(message)
	print("Fatal error: " + message)
	get_tree().quit()

# Run a simple command with arguments, blocking, using OS.execute.
func exec(command, args=[], crash_on_fail=true):
	var debug = false
	
	if debug:
		print("exec: %s [%s]" % [command, PoolStringArray(args).join(", ")])
		
	var output = []
	var exit_code = OS.execute(command, args, true, output, true)
	output = output[0]
	
	if exit_code != 0 and crash_on_fail:
		helpers.crash("OS.execute failed: %s [%s] Output: %s" % [command, PoolStringArray(args).join(", "), output])
	
	if debug:
		print(output)

	return output

# Return the contents of a file. If no fallback_string is provided, crash when
# the file doesn't exist.
func read_file(path, fallback_string=null):
	if debug_file_io:
		print("reading " + path)
	var file = File.new()
	var open_status = file.open(path, File.READ)
	if open_status == OK:
		var content = file.get_as_text()
		file.close()
		return content
	else:
		if fallback_string != null:
			return fallback_string
		else:
			helpers.crash("File %s could not be read, and has no fallback" % path)

func write_file(path, content):
	if debug_file_io:
		print("writing " + path)
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string(content)
	file.close()
	return true
