from os import walk

def join_texts(texts):
	return '\n'.join(texts)

def join_folders_content(folders):
	texts = []
	texts.append('DELIMITER $$\n')
	for folder in folders:
		texts.append(join_files(folder))
	texts.append('DELIMITER ;\n')
	return '\n'.join(texts)

def join_files(folder):
	texts = []
	for file in files(f'./{folder}'):
		texts.append(text(f'./{folder}/{file}'))
	return '\n'.join(texts)

def files(path):
	for root, dirs, files in walk(path):
		return [f for f in files if f.endswith('.sql')]

def text(file):
	with open(file, 'r') as stream:
		return stream.read()

def save(file, text):
	with open(file, 'w') as stream:
		stream.write(text)
