<?xml version='1.0' encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'>  
	<xsl:output method="text" omit-xml-declaration="yes" indent="no"/>
	<!-- 
	  <xsl:variable name=""></xsl:variable>
	  -->

	<xsl:variable name="functions">Funktionen</xsl:variable>
	<xsl:variable name="data">Daten</xsl:variable>
	<xsl:variable name="participants">Mitwirkende</xsl:variable>
	<xsl:variable name="client">Auftraggeber</xsl:variable>
	<xsl:variable name="tests">Testfälle</xsl:variable>
	<xsl:variable name="functionPrefix">F</xsl:variable>
	<xsl:variable name="dataPrefix">D</xsl:variable>
	<xsl:variable name="testPrefix">T</xsl:variable>
	<xsl:template match="b">\textbf{<xsl:value-of select="."/>}</xsl:template>
	<xsl:template match="br">\\</xsl:template>
	<xsl:template match="list">

		<xsl:choose>
			<xsl:when test="item/@name">
				\begin{description}
				<xsl:for-each select="item">
					\item[<xsl:apply-templates select="@name" />:] <xsl:apply-templates select="." />
				</xsl:for-each>
				\end{description}
			</xsl:when>
			<xsl:otherwise>
				\begin{itemize}
				<xsl:for-each select="item">
					\item <xsl:apply-templates select="." />
				</xsl:for-each>
				\end{itemize}
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="link">
		\hyperref[<xsl:value-of select="@to" />]{\textit{<xsl:value-of select="." />}}
	</xsl:template>
	<xsl:template match="img">
		\includegraphics[width=\linewidth]{tex/<xsl:value-of select="@src" />}
	</xsl:template>

	<xsl:template match="/featurelist">
		<!-- Remove review before publishing -->
		\documentclass[a4paper, 11pt, pdftex, fleqn]{article}
		\usepackage{amsmath,amssymb,geometry}
		\usepackage[mathletters]{ucs}
		\usepackage[utf8]{inputenc}
		 \usepackage[T1]{fontenc}
		 \usepackage{lmodern}
		\usepackage[breaklinks=true,unicode=true]{hyperref}
		<!-- Use another language-package -->
		\usepackage[ngerman]{babel}
		\usepackage{color,colortbl}
		\usepackage{fancyhdr}
		\usepackage{graphicx}
		\usepackage{lastpage}
		\usepackage{hyperref}
			

		\markboth{left headmark}{right headmark}%


		\setlength{\parindent}{0pt}
		\setlength{\parskip}{6pt plus 2pt minus 1pt}
		\setcounter{secnumdepth}{0}
		\pagestyle{fancy}
		\fancyhead[L]{<xsl:apply-templates select="/featurelist/header_title" />}
		\fancyfoot[L]{}
		\fancyfoot[R]{Stand \today}
		\fancyfoot[C]{\thepage\ von \pageref{LastPage}}

		\begin{document}

		<!-- First Page -->

		\thispagestyle{empty}

		\vspace*{3cm}
		\begin{center}
		\Large{<xsl:apply-templates select="/featurelist/title" />}\\
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
			\item[<xsl:apply-templates select="." />] <xsl:value-of select="@function" />
		</xsl:for-each>
		\end{description}

		\end{center}

		\vspace*{2cm} 

		\begin{flushleft}
		\textbf{<xsl:copy-of select="$client" />: <xsl:apply-templates select="client" />} 
		\end{flushleft}

		\newpage
		\tableofcontents \newpage
		<xsl:apply-templates select="description" />

		<!-- Other pages -->
		<xsl:for-each select="/featurelist/features/feature">
			<xsl:call-template name="feature" />
		</xsl:for-each>
		\end{document}
	</xsl:template>

	<xsl:template name="short">
		<xsl:for-each select="ancestor-or-self::feature/@short">
			<xsl:value-of select="normalize-space(.)"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="feature">
		<xsl:choose>
			<xsl:when test="count(ancestor-or-self::feature) = 1">
				\newpage
				\part{<xsl:apply-templates select="@name" />}
			</xsl:when>
			<xsl:when test="count(ancestor-or-self::feature) = 2">
				\section{<xsl:apply-templates select="@name" />}
			</xsl:when>
			<xsl:when test="count(ancestor-or-self::feature) = 3">
				\subsection{<xsl:apply-templates select="@name" />}
			</xsl:when>
			<xsl:when test="count(ancestor-or-self::feature) = 4">
				\paragraph{<xsl:apply-templates select="@name" />}
			</xsl:when>
		</xsl:choose>
		\label{<xsl:call-template name="short"/>}



		<xsl:apply-templates select="description" />

		<xsl:if test="functions">


			\paragraph{<xsl:copy-of select="$functions" />}
			\label{<xsl:copy-of select="$functionPrefix" /><xsl:call-template name="short"/>}
			\begin{description}
			<xsl:for-each select="functions/function">
				\item[<xsl:copy-of select="$functionPrefix" /><xsl:call-template name="short"/><xsl:number />] <xsl:apply-templates/>
				\label{<xsl:copy-of select="$functionPrefix" /><xsl:call-template name="short"/><xsl:number />}
			</xsl:for-each>
			\end{description}
		</xsl:if>

		<xsl:if test="data">
			\paragraph{<xsl:copy-of select="$data" />}
			\label{<xsl:copy-of select="$dataPrefix" /><xsl:call-template name="short"/>}

			<xsl:apply-templates select="data/description"/>
			<xsl:if test="data/item">
				\begin{description}
				<xsl:for-each select="data/item">
					\item[<xsl:copy-of select="$dataPrefix" /><xsl:call-template name="short" /><xsl:number />] <xsl:apply-templates/>
					\label{<xsl:copy-of select="$dataPrefix" /><xsl:call-template name="short"/><xsl:number />}
				</xsl:for-each>
				\end{description}
			</xsl:if>
		</xsl:if>

		<xsl:if test="tests">
			\paragraph{<xsl:copy-of select="$tests" />}
			\label{<xsl:copy-of select="$testPrefix" /><xsl:call-template name="short"/>}

			<xsl:apply-templates select="tests/description"/>
			<xsl:if test="tests/test">
				\begin{description}
				<xsl:for-each select="tests/test">
					\item[<xsl:copy-of select="$testPrefix" /><xsl:call-template name="short" /><xsl:number />] <xsl:apply-templates/>
					\label{<xsl:copy-of select="$testPrefix" /><xsl:call-template name="short"/><xsl:number />}
				</xsl:for-each>
				\end{description}
			</xsl:if>
		</xsl:if>

		<xsl:for-each select="features/feature">
			<xsl:call-template name="feature" />
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
