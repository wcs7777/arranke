from helper import save, join_folders_content

def main():
	save(
		'procedures-bundle.sql',
		join_folders_content([
			'advertisement',
			'car',
			'car-properties',
			'dealer',
			'garage',
			'individual',
			'offer',
			'user',
			'dealer',
		]),
	)

if __name__ == '__main__':
	main()
