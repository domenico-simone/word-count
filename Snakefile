rule alldata2:
    input:
        'results/abyss.png',
        'results/results.txt'

rule alldata:
    input:
        'processed_data/isles.dat',
        'processed_data/abyss.dat',
        'processed_data/last.dat'
    output:
        'results/results.txt'
    shell:
        'python source/zipf_test.py processed_data/abyss.dat processed_data/isles.dat processed_data/last.dat > results/results.txt'

# Count words.
rule count_words:
    input: 'data/isles.txt'
    output: 'processed_data/isles.dat'
    shell: 'python source/wordcount.py data/isles.txt processed_data/isles.dat'

rule count_words_abyss:
     input:  'data/abyss.txt'
     output: 'processed_data/abyss.dat'
     shell:  'python source/wordcount.py data/abyss.txt processed_data/abyss.dat'

rule count_words_last:
     input:  'data/last.txt'
     output: 'processed_data/last.dat'
     shell:  'python source/wordcount.py data/last.txt processed_data/last.dat'

# plot
rule plot_abyss:
    input: 'processed_data/abyss.dat'
    output: 'results/abyss.png'
    shell:
        """
        python source/plotcount.py processed_data/abyss.dat results/abyss.png
        """

rule clean:
    shell:
        """
        rm -f processed_data/*.dat
        rm -f results/results.txt
        rm -f results/abyss.png
        """
