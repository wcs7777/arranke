from helper import save, join_texts, text
import all_bundler

def main():
	all_bundler.main()
	save(
		'all-with-test-data-bundle.sql',
		join_texts([
			text('all-bundle.sql'),
			text('test-data.sql'),
		]),
	)

if __name__ == '__main__':
	main()
