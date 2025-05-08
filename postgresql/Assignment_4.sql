-- structure that we need to follow: SELECT purpose FROM taxdata WHERE purpose ~ '^[A-Z]' ORDER BY purpose DESC LIMIT 3;
--Regex Used:
^[A-Z ]+$


--Explanation of the Regex:
--^ → Start of the string (ensures matching begins at the start)
--$ → End of the string (ensures matching goes to the end)
--[A-Z ] → Matches: Uppercase letters (A through Z) Space character ( )
-- + → One or more occurrences of the preceding pattern

-- Final query to get the first three records:

SELECT purpose
FROM taxdata
WHERE purpose ~ '^[A-Z ]+$'
ORDER BY purpose DESC
LIMIT 3;

-- Results:
YOUTH WRITING WORKSHOPS ACADEMIC SUPPORT
YOUTH WRESTLING CLUB SUPPORTED YOUTH WRESTLING
YOUTH WORK THERAPY PROGRAMS

