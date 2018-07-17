multiplot <- function(..., plotlist=NULL, file, cols=1, rows=1) {
  require(grid)
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  numPlots = length(plots)
	
	i = 1
	while (i < numPlots) {
		numToPlot <- min(numPlots-i+1, cols*rows)
		# Make the panel
		# ncol: Number of columns of plots
		# nrow: Number of rows needed, calculated from # of cols
		layout <- matrix(seq(i, i+cols*rows-1), ncol = cols, nrow = rows, byrow=T)
		if (numToPlot==1) {
		  print(plots[[i]])
		} else {
		  # Set up the page
		  grid.newpage()
		  pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
		  # Make each plot, in the correct location
		  for (j in i:(i+numToPlot-1)) {
		    # Get the i,j matrix positions of the regions that contain this subplot
		    matchidx <- as.data.frame(which(layout == j, arr.ind = TRUE))
		    print(plots[[j]], vp = viewport(layout.pos.row = matchidx$row,
		                                    layout.pos.col = matchidx$col))
		  }
		}
		i <- i+numToPlot
  }
}

normalizeByRows <- function (df, rsum=1)
{
	while (any(abs((rowSums(df)-rsum))>1e-13)) {
		df <- rsum*(df / rowSums(df))
	}
	return(df)
}
normalizeByCols <- function (df, csum=1, level=NULL, delim="\\|")
{
	if (is.null(level)) {
		while (any(abs((colSums(df)-csum))>1e-13 & colSums(df)!=0, na.rm=T)) {
			missing <- which(colSums(df)==0)
			df <- sweep(df, 2, colSums(df)/csum, "/")
			df[,missing] <- 0
		}
	} else {
	 tmp <- df
	 tmp$taxa <- rownames(tmp)
	 tmp$splitter <- factor(unlist(lapply(rownames(tmp), function(x) unlist(strsplit(x, delim))[level])))
	 names <- rownames(tmp)[order(tmp$splitter)]
	 tmp <- ddply(tmp, .(splitter), function(x) {
	 		x <- x[, setdiff(colnames(x), c("taxa", "splitter"))]
			while (any(abs((colSums(x)-csum))>1e-13 & colSums(df)!=0, na.rm=T)) {
				x <- sweep(x, 2, colSums(x)/csum, "/")
			}
			x
		})
		rownames(tmp) <- names
		df <- tmp[, setdiff(colnames(tmp), "splitter")]
	}
	return(df)
}

renameLevelsWithCounts <- function(fvec, originalLevelsAsNames=FALSE) {
	tab <- table(fvec)
	retval <- sprintf("%s (n=%d)", fvec, tab[unlist(lapply(fvec, function(x) match(x, names(tab))))])
#	newlevels <- sprintf("%s (n=%d)", levels(fvec), tab[levels(fvec)])
	newlevels <- sprintf("%s (n=%d)", levels(fvec), tab[unlist(lapply(names(tab), function(x) which(levels(fvec)==x)))])
	retval <- factor(retval, levels=newlevels)
	if (originalLevelsAsNames) {
		names(retval) <- fvec
	}
	return(retval)
}

# get selected taxonomy, or if unavailable the lowest taxonomy available
getTaxonomy <- function(otus, tax_tab, level, na_str = c("unidentified", "NA", "", "uncultured")) {
	ranks <- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species", "SV")
	if (level=="SV") {
		retval=rownames(tax_tab)
	} else {
		sel <- ranks[1:match(level, ranks)]
		inds <- apply(tax_tab[otus,sel], 1, function(x) max(which(!(x %in% na_str))))
		retval <- as.data.frame(tax_tab)[cbind(otus, ranks[inds])]
		retval[inds!=match(level, ranks)] <- paste(na_str[1], retval[inds!=match(level, ranks)], sep="_")
	}
	return(retval)
}
