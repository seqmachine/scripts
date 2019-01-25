#!/usr/bin/python
# -*- coding: utf-8 -*-
#Dec. 25, 2018

import MySQLdb as mdb
import sys


#infile="snp_info.tab2"

infile=sys.argv[1] #the snp table to be inserted into the database

passwd=sys.argv[2] #database password

def readTAB(infile):
	#infile is like per row "ACTN3\trs1815739\t11\t66560624"

	allList=[]
	snpList=[]	

	fh=open(infile, "r")
	for line in fh:
		line=line.strip("\n")
		snpList=line.split("\t")
		allList.append(snpList)
		snpList=[]

	return allList


results=readTAB(infile)
#print results

con = mdb.connect('localhost', 'root', passwd, 'snpdb')

with con:
	cur = con.cursor()
	#cur.execute("insert into snp_info(gene, snpID, chr, pos) values('ACTN3', 'rs1815739', '11', '66560624')")

      	cur.execute("drop table if exists snp_info")
	
	cur.execute("create table snp_info ( gene varchar(50) not null, snpID varchar(50) not null, chr varchar(10) not null, pos varchar(50) not null, primary key (gene, snpID) )")
	for snpList in results:
		#print snpList
		sql=("insert into snp_info(gene, snpID, chr, pos) values(%s, %s, %s, %s)")
		val=(snpList[0], snpList[1], snpList[2], snpList[3])
		cur.execute(sql, val)
		con.commit()	
	

	cur.execute("select * from snp_info")
	print cur.fetchall() 
	#con.commit()
	#con.close()

	
	#cur.execute("DROP TABLE IF EXISTS Writers")
        #cur.execute("CREATE TABLE Writers(Id INT PRIMARY KEY AUTO_INCREMENT, \
        #         Name VARCHAR(25))")
	#cur.execute("INSERT INTO Writers(Name) VALUES('Jack London')")

