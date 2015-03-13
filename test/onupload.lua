function onupload()
    ngx.req.read_body();
    local post_args = ngx.req.get_post_args();                    -- 读取参数
    local tab_params = getFormParams_FixBug(post_args);        -- 处理参数错误

    pressFile(tab_params);        -- 处理文件
    -- ngx.log(ngx.ERR,"#############@" ,tab_params["callback"],"@###########");
    if (tab_params["callback"] and tab_params["callback"] ~= "") then
        ngx.exec(tab_params["callback"],tab_params);  -- 转发请求
    else
        ngx.say("Callback not specified!!");
    end
end


--[[
    处理文件
    主要进行 创建目录 ＆ 移动文件 等操作。
]]
function pressFile(params)
    local dirroot = "/B2B/uploadfiles/";
    local todir = params["user_name"].."/";
    if(params["sub_path"]) then
        todir = params["sub_path"].."/"..todir;
    end
    if(trim(params["use_date"]) == "Y") then
         todir = todir..os.date('%Y-%m-%d').."/"
    end
    todir = trim(todir);
    local tofile = todir..params["file_md5"]..getFileSuffix(params["file_name"]);
    tofile = trim(tofile);

    local sh_mkdir = "mkdir -p " ..dirroot..todir;
    local sh_mv = "mv "..trim(params["temp_path"]).." "..dirroot..tofile;

    params["file_path"] = tofile;
    if(os.execute(sh_mkdir) ~= 0) then
        ngx.exec("/50x.html");
    end
    if(os.execute(sh_mv) ~= 0) then
        ngx.exec("/50x.html");
    end
end

function getFileSuffix(fname)
    local idx,idx_end = string.find(fname,"%.");
    return string.sub(fname,idx_end);
end

function trim(str)
    if(str ~= nil) then
        return string.gsub(str, "%s+", "");
    else
        return nil;
    end
end

function urlencode(str)
    if (str) then
        str = string.gsub (str, "\n", "\r\n")
        str = string.gsub (str, "([^%w ])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
        str = string.gsub (str, " ", "+")
    end
    return str
end
function urldecode(str)
  str = string.gsub (str, "+", " ")
  str = string.gsub (str, "%%(%x%x)",
      function(h) return string.char(tonumber(h,16)) end)
  str = string.gsub (str, "\r\n", "\n")
  return str
end

--[[
 * 修复form提交后参数转发丢失问题。
 * 文件上传成功后，转发到另一个URL作后继处理。此时表单数据和文件信息丢失。原因不明，猜测可能是上传模块与lua模块冲突导致。
 * 转发过来的from内容lua收到后现为如下形式的table对象：
-----------------------------5837197829760
Content-Disposition: form-data; name"test_name"

交易.jpg
-----------------------------5837197829760
Content-Disposition: form-data; name="test_content_type"

image/jpeg
-----------------------------5837197829760
 * 因此自行处理来分离出表单内容。
 * 使用分离字符串的方式。注意！！！字段名称中不能使用半角双引号。
]]
function getFormParams_FixBug(post_args)
    local str_params;
    if (post_args) then
        for key,val in pairs(post_args) do
            str_params = key ..val;
        end
    else
        return nil;
    end

    local tab_params = {};
    local str_start = " name";
    local str_start_len = string.len(str_start);
    local str_end = "%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-";
    local str_sign = "\"";
    local idx,idx_end = string.find(str_params,str_start);
    local i = 0;

    -- 如果字符串内仍有开始标记，则说明还有内容需要分离。继续分离到没内容为止。
    while idx do
        str_params = string.sub(str_params,idx_end); -- 截取开始标记后所有字符待用
        i = string.find(str_params,str_sign); -- 查找字段名开始处的引号索引
        str_params = string.sub(str_params,i+1); -- 去掉开始处的引号
        i = string.find(str_params,str_sign); -- 查找字段名结束位置的索引
        f_name = string.sub(str_params,0,i-1); -- 截取到字段名称

        str_params = string.sub(str_params,i+1); -- 去掉名称字段以及结束时的引号
        i,i2 = string.find(str_params,str_end); -- 查找字段值结尾标识的索引
        f_value = string.sub(str_params,1,i-1); -- 截取到字段值
        tab_params[f_name] = f_value;
        idx = string.find(str_params,str_start,0); -- 查找判断下一个字段是否存在的
    end
    tab_params["callback"] = urldecode(trim(tab_params["callback"]));

    return tab_params;
end

onupload();
