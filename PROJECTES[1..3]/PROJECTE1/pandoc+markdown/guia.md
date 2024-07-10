# COMANDES

```bash
convert fondo.jpg -brightness-contrast -20x0 fondooscuro.jpg
convert code.jpg -modulate 20 background.jpg 
pandoc presentacion.md -t beamer -o presentacion.pdf
mupdf -r 250 presentacion.pdf &
```

```bash
# Diapositiva con Texto Personalizado

\begin{columns}

\column{0.5\textwidth}
\justifying
**Texto en Negrita**

\textcolor{blue}{Texto en Azul}

\textsf{Texto en Sans-serif}

\texttt{Texto Monoespaciado}

\includegraphics[width=0.8\textwidth]{ruta/a/la/imagen.jpg}

\column{0.5\textwidth}
\justifying
*Texto en Cursiva*

\textcolor{green}{Texto en Verde}

\textsf{\textcolor{red}{Texto en Sans-serif y Rojo}}

\texttt{\textcolor{orange}{Texto Monoespaciado y Naranja}}

\end{columns}
```
