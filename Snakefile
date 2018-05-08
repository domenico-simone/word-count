# This is a "hidden" version of the final Snakefile if students want/need 
# to run the instructor's copy.

# our zipf analysis pipeline
DATA = glob_wildcards('data/{book}.txt').book

localrules: all, clean, make_archive

rule all:
    input:
        'zipf_analysis.tar.gz'

# delete everything so we can re-run things
# deletes a little extra for purposes of lesson prep
rule clean:
    shell:  
        '''
        rm -rf processed_data results source/__pycache__
        rm -f zipf_analysis.tar.gz 
        '''

# count words in one of our "books"
rule count_words:
    input:  
        wc='source/wordcount.py',
        book='data/{file}.txt'
    output: 'processed_data/{file}.dat'
    threads: 4
    log: 'processed_data/{file}.log'
    shell:
        '''
        echo "Running {input.wc} with {threads} cores on {input.book}." &> {log} &&
            ./{input.wc} {input.book} {output} >> {log} 2>&1
        '''

# create a plot for each book
rule make_plot:
    input:
        plotcount='source/plotcount.py',
        book='processed_data/{file}.dat'
    output: 'results/{file}.png'
    resources: gpu=1
    shell: './{input.plotcount} {input.book} {output}'

# generate summary table
rule zipf_test:
    input:  
        zipf='source/zipf_test.py',
        books=expand('processed_data/{book}.dat', book=DATA)
    output: 'results/results.txt'
    shell:  './{input.zipf} {input.books} > {output}'

# create an archive with all of our results
rule make_archive:
    input:
        expand('results/{book}.png', book=DATA),
        expand('processed_data/{book}.dat', book=DATA),
        'results/results.txt'
    output: 'zipf_analysis.tar.gz'
    shell: 'tar -czvf {output} {input}'
