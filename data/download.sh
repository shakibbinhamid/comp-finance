
mkdir -p Updated

for i in ^FTSE LLOY.L VOD.L GLEN.L BP.L BARC.L HSBA.L TSCO.L CNA.L AV.L BA.L RDSB.L BLT.L RBS.L TW.L ITV.L LGEN.L GSK.L OML.L KGF.L MRW.L RIO.L SKY.L STAN.L SBRY.L RR.L AAL.L BT-A.L NG.L MKS.L SGE.L;

do
  filename="Updated/"$i".csv"

  url="http://real-chart.finance.yahoo.com/table.csv?s="$i"&a=01&b=25&c=2014&d=01&e=25&f=2017&g=d&ignore=.csv"

  curl -o $filename $url
done

