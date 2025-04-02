function color = GetColorByIndex(idx)
    % 根据输入的整数生成一个颜色，不同整数生成的颜色不同
    
    % 使用 HSV 色相循环，保证颜色差异明显
    hue = mod(idx * 0.618, 1); % 黄金分割比例，避免颜色相近
    color = hsv2rgb([hue, 0.9, 0.9]); % 高饱和度、高亮度
end