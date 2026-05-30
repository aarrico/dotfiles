if type -q rbenv
    for cmd in ruby gem bundle rbenv
        function $cmd --inherit-variable cmd --wraps $cmd
            functions -e ruby gem bundle rbenv
            rbenv init - fish | source
            $cmd $argv
        end
    end
end
