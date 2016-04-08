import csv

path = '/Users/richardbanyi/Developer/Environments/Data/dw/'

source_csv = open(path+'f.csv', 'r')
base_csv = open(path+'f2.csv', 'w')

reader = csv.reader(source_csv)
writer = csv.writer(base_csv)

for row in reader:
    writer.writerow(row)

