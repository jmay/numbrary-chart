url = "http://localhost.com:3000/sources/f7563d1f8a-nationa-income/data.csv"
tmpfile = tempfile()
download.file(url = url, destfile = tmpfile)
d <- read.table(tmpfile, header = TRUE, sep = ",")
unlink(tmpfile)

png(filename = 'natincome.png', width = 600, height = 400)

plot(d,
  type = 'l',
  xlab = '',
  ylab = '',
  axes = FALSE,
  col = 'blue',
  lwd = 5,
  ylim  = c(0,12000),
  xlim = c(1927, 2007),
  xaxs = "i",
  yaxs = "i"
  )
abline(
  h = c(2000, 4000, 6000, 8000, 10000, 12000),
  col = '#cccccc',
  lwd = 0.5)

axis(1,
  at = c(1910,1930,1940,1950,1960,1970,1980,1990,2000,2005,2010),
  labels = c('','1930','1940','1950','1960','1970','1980','1990','2000','2005', ''),
  pos = 0,
  mgp = c(2,0.25,0),
  tcl = -0.2,
  cex.axis = 0.85,
  col = 'black'
  )

axis(2,
  at = c(0, 2000, 4000, 6000, 8000, 10000, 12000),
  labels = c('0', '$2,000', '$4,000', '$6,000', '$8,000', '$10,000', '$12,000'),
  pos = 1927,
  mgp = c(2,0.5,0),
  tcl = -0.2,
  las = 1,
  cex.axis = 0.80,
  col = 'black')

dev.off()
system('open natincome.png')
