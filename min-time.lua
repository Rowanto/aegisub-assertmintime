-- Copyright (c) 2015, Rowanto Rowanto <rowanto@gmail.com>
--
-- Permission to use, copy, modify, and distribute this software for any
-- purpose with or without fee is hereby granted, provided that the above
-- copyright notice and this permission notice appear in all copies.
--
-- THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
-- WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
-- MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
-- ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
-- WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
-- ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
-- OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
--
-- $Id$

local tr = aegisub.gettext

script_name = tr"Assure Minimum Time"
script_description = tr"Join lines until the minimum time is fulfilled"
script_author = "Rowanto Rowanto"
script_version = "1"

function assure_min_time(subtitle, selected, active)

    local shortest_time = 5000

    local short_line
    local short_line_length
    local short_line_index
    local concatenate_next = false

    local to_be_deleted = {}

    for subtitle_index,line_number in ipairs(selected) do
        --Read in the line
        local line = subtitle[line_number]

        --Check the length
        local line_length = line.end_time - line.start_time

        --Concatenate line if exists
        if concatenate_next then
            short_line.text = short_line.text .. ' ' .. line.text
            short_line_length = short_line_length + line_length
            table.insert(to_be_deleted, line_number)
            if short_line_length > shortest_time then
                short_line.end_time = line.end_time
                subtitle[short_line_index] = short_line
                concatenate_next = false
            end
        else
            if line_length < shortest_time then
                short_line = line
                short_line_length = line_length
                short_line_index = line_number
                concatenate_next = true
            end
        end
    end

    subtitle.delete(to_be_deleted)
    return {}
end

aegisub.register_macro(script_name, script_description, assure_min_time)