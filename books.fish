function books
    set selector $argv[1]
    set criteria author title publisher series tag tags
    if contains $selector $criteria
        set query $argv[2..-1]
    else
        set selector title
        set query $argv
    end

    # set filenames (find-books $query)
    set filenames (find-books2 $selector $query)
    set pdfs (filter filenames .pdf)
    set epubs (filter filenames .epub)
    set filenames $epubs $pdfs
    set books (apply extract-title filenames | sort | uniq)
    
    set nbooks (count $books)

    # echo query $query
    # echo filenames $filenames
    # echo pdfs $pdfs
    # echo epubs $epubs
    # echo books $books
    # echo nbooks $nbooks

    switch $nbooks
        case 0
            echo "Search produced no results"
        case 1
            if contains $pdfs $filenames
                open $pdfs &
            else 
                open $epubs &
            end
            
        case "*"
            # given many results find out if one is an exact match
            for i in $books
                if match $i $query
                    #ok so one is an exact match
                    for j in $filenames
                        set title (echo $j | extract-title)
                        # lets find the filename which contains the title 
                        # that we want and open it
                        if match $title $query
                            open $j
                        end
                    end
                    return 0
                end
            end
            # so no exact match so show a menu and pipe the users choice to 
            # books where it will now be an exact match 
            fuzzymenu (println $books | sed 's/_/:/g')
            #fuzzymenu sets global fquery variable because fzf is broken within variable sub in fish
            books $fquery
        end
end

function find-books
    set query $argv
    set correctedquery (echo $query | sed 's/:/_/g')
    set returnval (calibredb list -s "title:~^.*"{$query}"" -f formats --for-machine | grep /home | cut -d '"' -f2 | grep -i "$correctedquery")
    println $returnval
 end

function find-books2
    set selector $argv[1]
    set query $argv[2..-1]
    set correctedquery (echo $query | sed 's/:/_/g')
    set returnval (calibredb list -s "$selector:~^.*"{$query}"" -f formats --for-machine | grep /home | cut -d '"' -f2 | grep -i "$correctedquery")
    println $returnval
 end

function find-book-id
    calibredb list -s "title:$argv" -f formats --for-machinee| grep '"id":' | cut -d ":" -f2 | cut -d '"' -f2 | cut -d "," -f1 | trim
end

function extract-title
    if exists $argv
        echo $argv | cut -d "." -f1 | cut -d "/" -f7 | cut -d "(" -f1 | trim
    else
        while read -l line
            echo $line | cut -d "." -f1 | cut -d "/" -f7 | cut -d "(" -f1 | trim
        end
    end
end
