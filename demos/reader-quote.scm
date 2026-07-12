; line comment is skipped and 'x reads as (quote x).
(read-from-string "; a comment
 'x")                                   ; => (quote x)
