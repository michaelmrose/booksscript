function books
    set query $argv

    set filenames (calibredb list -s "title:~^.*"{$query}"" -f formats --for-machine | grep /home | cut -d '"' -f2 | grep -i "$query")
    set pdfs (filter filenames pdf)
    set epubs (filter filenames epub)
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
                            # set thebook (echo $j | sed 's/_/:/g')
                            open $j
                        end
                    end
                    return 0
                end
            end
            # so no exact match so show a menu and pipe the users choice to 
            # books where it will now be an exact match 
            fuzzymenu $books | pipeit books
        end
end

function find-books
    set returnval (calibredb list -s "title:~^.*"{$argv}"" -f formats --for-machine | grep /home | cut -d '"' -f2 | grep -i "$argv")
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
