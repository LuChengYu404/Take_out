function num=xml2num(xml,expr)
%��ȡxml�е����� xmlΪ�ַ�
%����ж���ƥ��Ļ� ȡ��һ��
%���û��ƥ�� ����0
    xmlmatch=regexp(xml,expr,'match');
    if(isempty(xmlmatch)==0)
        num=Lab2num(xmlmatch{1},expr);
    else
        num=0;
    end
end

function num=Lab2num(lab,expr)
%��ȡlab�е�����
    s=max(size(expr));
    s=(s-4)/2;
    l=max(size(lab));
    str=lab(s+1:l-s-1);
    num=str2double(str);
end