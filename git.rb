#!/usr/bin/env ruby

# tiny Ruby script to automate git bc we are giga chads here
# feel free to use it, or ignore it
# and yes, in Ruby because Bash's syntax fucking sucks

print('Enter the files to commit: ')

files_to_commit = gets.chomp

unless files_to_commit.empty?

	`git add #{files_to_commit}`

else

	puts "you fucking moron, you didn't add any files, exiting now, bye"
	exit 1

end

puts `git diff --cached --name-only`

print('Enter the commit message: ')

commit_message = gets.chomp

unless commit_message.empty?

	`git commit -S -m "#{commit_message}"`
	`git push`
	exit 0

end

puts "can you fucking give me a commit message to work with? As if I were asking for too much ffs, exiting now"
`git reset`
exit 1
