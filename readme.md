# EEBO-Travel

## General info

EEBO-Travel is a collection of travel reports from the first phase of [Early English Books Online](https://textcreationpartnership.org/tcp-texts/eebo-tcp-early-english-books-online/), a collection of transliterated English prints available under a CC0 license (i.e., in the public domain). EEBO-Travel is currently work in progress. The version distributed here has been normalized using VARD2 (Rayson & Baron 2008) and tagged using the TreeTagger (Schmid 1994), both **without manual correction**. Please keep this in mind when using the corpus. 

In the near future, we plan to manually correct the tagging of a small subset of the corpus that is balanced for different time spans and printing locations.


## How to use the corpus

The corpus files are distributed as VRT files for the [Corpus Workbench](http://cwb.sourceforge.net/). See the CWB website for installation instructions and tutorials. 

To encode the VRT files for CWB, you can use the code below. Replace `/corpora/data/` and `/usr/local/share/cwb/registry/` by the paths to your data repository and registry, respectively, and replace `path/to/vrt` by the path to the folder containing the VRT files.

```` bash
cwb-encode -c utf8 -v -x -d /corpora/data/eebotravel -F path/to/vrt -R /usr/local/share/cwb/registry/eebotravel -P lemma -P pos -P norm -P lang -S text:0+id+title+title_short+author+date+publisher+pubPlace -S p -S item -S hi:0+rend -S g:0+ref -S gap:0+reason+resp+extent - S pb:0+facs+rendition -S head -S expan -S div -S group -S front

cwb-makeall -r /usr/local/share/cwb/registry/ eebotravel

cwb-huffcode -r /usr/local/share/cwb/registry/ eebotravel

cwb-compress-rdx -r /usr/local/share/cwb/registry/ eebotravel

````


## Normalization and POS tagging

The first column contains the original word form, the second column the POS tag, the third column the lemma, and the fourth column the normalised (VARDed) word form. As the POS tagging is based on the normalised word form, so is the tokenisation: In some cases, a word like *ſhalbe* is split up in two words in normalisation (*shall be*). In these cases, the original word form is repeated but marked by three brackets:

| word | lemma | pos | norm |
| -------: | :----: | :----: | ----- |
| euer | ever | RB | ever  |                    
| more | RBR | more | more   |                   
| ſhalbe | shall | MD | shall |                         
| <span style = "color:darkred"> (((ſhalbe))) </span> | be | VB | be  |                               
| for | IN | for | for  |               
| bi | NNS | \<unknown\> | bi  |
| cauſe | VBP | cause | cause |   


## License

This work is licensed under a Creative Commmons BY-SA 4.0 License. 

## References
- Baron, Alistair & Paul Rayson. 2008. VARD 2: A tool for dealing with spelling variation in historical corpora. Proceedings of the Postgraduate Conference in Corpus Linguistics.

- Schmid, Helmut. 1994. Probabilistic Part-of-Speech Tagging Using Decision Trees. Proceedings of the International Conference on New Methods in Language Processing. Manchester.


