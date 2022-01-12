from helper import save, join_texts, text
import procedures_bundler

def main():
	procedures_bundler.main()
	save(
		'all-bundle.sql',
		join_texts([
			text('database.sql'),
			text('procedures-bundle.sql'),
		]),
	)

if __name__ == '__main__':
	main()
