<?xml version='1.0' encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>  
	<xsl:output method="text" omit-xml-declaration="yes" indent="no"/>
	<xsl:variable name="functions">Functions</xsl:variable>
	<xsl:variable name="data">Data</xsl:variable>
	<xsl:variable name="participants">Participants</xsl:variable>
	<xsl:variable name="client">Client</xsl:variable>
	<xsl:variable name="tests">Test cases</xsl:variable>
	<xsl:variable name="functionPrefix">F</xsl:variable>
	<xsl:variable name="dataPrefix">D</xsl:variable>
	<xsl:variable name="testPrefix">T</xsl:variable>

	<xsl:template match="/featurelist">
		<!-- Remove review before publishing -->
		\documentclass[a4paper, 11pt, pdftex, fleqn, review]{article}
		\usepackage{amsmath,amssymb,geometry}
		\usepackage[mathletters]{ucs}
		\usepackage[utf8x]{inputenc}
		\usepackage[breaklinks=true,unicode=true]{hyperref}
		<!-- Use another language-package -->
		\usepackage[ngerman]{babel}
		\usepackage{color,colortbl}
		\usepackage{fancyhdr}
		\usepackage{graphicx}


		\setlength{\parindent}{0pt}
		\setlength{\parskip}{6pt plus 2pt minus 1pt}
		\setcounter{secnumdepth}{0}
		\pagestyle{fancy}

		\begin{document}

		<!-- First Page -->

		\thispagestyle{empty}

		\vspace*{3cm}
		\begin{center}
		\Large{<xsl:value-of select="/featurelist/title" />}\\
		\end{center}

		\begin{center}
		\textbf{\LARGE{}}
		\end{center}

		\begin{center}
		\today
		\end{center}

		\begin{verbatim}

		\end{verbatim}
		\begin{center}
		\vspace*{1.5cm}

		\textbf{<xsl:copy-of select="$participants" />}
		\\
		\begin{description}
		<xsl:for-each select="participants/participant">
			\item[<xsl:value-of select="." />] <xsl:value-of select="@function" />
		</xsl:for-each>
		\end{description}

		\end{center}

		\vspace*{2cm} 

		\begin{flushleft}
		\textbf{<xsl:copy-of select="$client" />: <xsl:value-of select="client" />} 
		\end{flushleft}

		\newpage
		\tableofcontents \newpage
		<!-- Other pages -->
		<xsl:for-each select="/featurelist/features/feature">
			<xsl:call-template name="feature" />
		</xsl:for-each>
		\end{document}
	</xsl:template>
	<xsl:template name="feature">
		\section{<xsl:value-of select="@name" />}

		<xsl:value-of select="description" />

		<xsl:if test="functions">
			\paragraph{<xsl:copy-of select="$functions" />}
			\begin{description}
			<xsl:for-each select="functions/function">
				\item[<xsl:copy-of select="$functionPrefix" /><xsl:value-of select="../../@short" /><xsl:number />] <xsl:value-of select="." />
			</xsl:for-each>
			\end{description}
		</xsl:if>

		<xsl:if test="data">
			\paragraph{<xsl:copy-of select="$data" />}
			\begin{description}
			<xsl:for-each select="data/item">
				\item[<xsl:copy-of select="$dataPrefix" /><xsl:value-of select="../../@short" /><xsl:number />] <xsl:value-of select="." />
			</xsl:for-each>
			\end{description}
		</xsl:if>

		<xsl:if test="tests">
			\paragraph{<xsl:copy-of select="$tests" />}
			\begin{description}
			<xsl:for-each select="tests/test">
				\item[<xsl:copy-of select="$testPrefix" /><xsl:value-of select="../../@short" /><xsl:number />] <xsl:value-of select="." />
			</xsl:for-each>
			\end{description}
		</xsl:if>

		<xsl:for-each select="features/feature">
			<xsl:call-template name="feature" />
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
