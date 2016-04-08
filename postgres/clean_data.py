import csv, os, glob

path_sources = '/Users/richardbanyi/Developer/Environments/Data/dw/Data_Sources/*.csv'
path_cleaned = '/Users/richardbanyi/Developer/Environments/Data/dw/cleaned_data/'
csv_files = glob.glob(path_sources)

for file in csv_files:
    source = open(file, 'r')
    source_name = os.path.basename(file).split('_')
    cleaned_csv = open(path_cleaned+source_name[0]+'_cleaned.csv', 'w')
    reader = csv.reader(file)
    writer = csv.writer(cleaned_csv)

    for row in reader:
        writer.writerow(row)
