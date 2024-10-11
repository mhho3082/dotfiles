(directive) @function
(directive_start) @function
(directive_end) @function
(comment) @comment @spell
((parameter) @include (#set! "priority" 110)) 
((php_only) @include (#set! "priority" 110)) 
((bracket_start) @punctuation.bracket (#set! "priority" 120)) 
((bracket_end) @punctuation.bracket (#set! "priority" 120)) 
(keyword) @function
