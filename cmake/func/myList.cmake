#
# Created by HFauto on 2022/12/26.
#

# 方便修改全局变量
function(update_cached name value)
    set("${name}" "${value}" CACHE INTERNAL "*** Internal ***" FORCE)
endfunction()
function(update_cached_list name)
    set(_tmp_list "${${name}}")
    list(APPEND _tmp_list "${ARGN}")
    list(REMOVE_DUPLICATES _tmp_list)
    update_cached(${name} "${_tmp_list}")
endfunction()
function(clean_cached_list name)
    set(_tmp_list "${${name}}")
    FOREACH(val ${${name}})
        list(REMOVE_ITEM _tmp_list ${val})
    ENDFOREACH(val)
    update_cached(${name} "${_tmp_list}")
endfunction()