# merge_mztab_simple
#
# author: Oliver Alka
# 20.02.2019
#
# Merge mztab-m output from SIRIUS/CSI:FingerID
#


# packages
import os
import click
from os.path import normpath, basename

@click.command()
@click.option('--directory', '-in', envvar = 'directory', multiple = False, type = click.Path(), help = 'Path to directory with output csv files')
@click.option('--outfile', '-out', envvar = 'outfile', multiple = False, type = click.Path(), help = 'Path to save the output file')

	
def main(directory, outfile):

	MTD = [] # metadata
	SMH = [] # small molecule header
	SFH = [] # feature header
	SEH = [] # evidence header

	SML = [] # summary 
	SMF = [] # feature
	SME = [] # evidence

	read_once = True
	print(os.listdir(directory))
	for mztab_file in os.listdir(directory):
		if mztab_file.endswith(".mztab"):
			mztab_file_path = directory + mztab_file
			read_file = open(mztab_file_path, "r")
			lines = read_file.readlines()
			for line in lines:
				if read_once: # read headers only once
					if line.startswith("MTD"):
						MTD.append(line)
					if line.startswith("SMH"):
						SMH.append(line)
					if line.startswith("SFH"):
						SFH.append(line)
					if line.startswith("SEH"):
						SEH.append(line)
				if line.startswith("SML"):
					SML.append(line)
				if line.startswith("SMF"):
					SMF.append(line)
				if line.startswith("SME"):
					SME.append(line)
			read_file.close()
			read_once = False

	write_file = open(outfile, "w+")
	write_file.writelines(MTD)
	write_file.writelines("\n")
	write_file.writelines(SMH) 
	for element in SML:
		write_file.writelines(element)
	write_file.writelines("\n")
	write_file.writelines(SFH) 
	for element in SMF:
		write_file.writelines(element)
	write_file.writelines("\n")
	write_file.writelines(SEH) 
	for element in SME:
		write_file.writelines(element)
	write_file.close()

	print("Done")

if __name__ == "__main__":
    main()


