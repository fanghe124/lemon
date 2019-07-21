package com.mossle.disk.office2html;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.hwpf.converter.PicturesManager;
import org.apache.poi.hwpf.converter.WordToHtmlConverter;
import org.apache.poi.hwpf.usermodel.PictureType;
import org.apache.poi.xwpf.converter.core.BasicURIResolver;
import org.apache.poi.xwpf.converter.core.FileImageExtractor;
import org.apache.poi.xwpf.converter.xhtml.XHTMLConverter;
import org.apache.poi.xwpf.converter.xhtml.XHTMLOptions;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.w3c.dom.Document;

public class POIWordToHtml {
	private static final String ENCODING = "GB2312";// UTF-8

	public static byte[] wordToHtml(InputStream in, String ext, final String picturesPath, final String contextPath){
		File picturesDir = new File(picturesPath);
		
		boolean isCreated = false;
		if (!picturesDir.isDirectory()) {
			isCreated = picturesDir.mkdirs();
		}
		String content = null;
		ByteArrayOutputStream out = new ByteArrayOutputStream();
		try {
			if (ext.equals("doc")) {
				HWPFDocument wordDocument = new HWPFDocument(in);
				WordToHtmlConverter wordToHtmlConverter = new WordToHtmlConverter(
						DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument());
				wordToHtmlConverter.setPicturesManager(new PicturesManager() {
					@Override
					public String savePicture(byte[] content, PictureType pictureType, String suggestedName,
							float widthInches, float heightInches) {
						File file = new File(picturesPath + "\\" + suggestedName);
						FileOutputStream fos = null;
						try {
							fos = new FileOutputStream(file);
							fos.write(content);
							fos.close();
						} catch (Exception e) {
							e.printStackTrace();
						}
						return contextPath + "/" + suggestedName;
					}
				});
				wordToHtmlConverter.processDocument(wordDocument);
				Document htmlDocument = wordToHtmlConverter.getDocument();
				
				DOMSource domSource = new DOMSource(htmlDocument);
				StreamResult streamResult = new StreamResult(out);

				TransformerFactory tf = TransformerFactory.newInstance();
				Transformer serializer = tf.newTransformer();
				serializer.setOutputProperty(OutputKeys.ENCODING, ENCODING);
				serializer.setOutputProperty(OutputKeys.INDENT, "yes");
				serializer.setOutputProperty(OutputKeys.METHOD, "html");
				serializer.transform(domSource, streamResult);
				out.close();
			} else if (ext.equals("docx")) {
				XWPFDocument document = new XWPFDocument(in);

				XHTMLOptions options = XHTMLOptions.create();
				options.setExtractor(new FileImageExtractor(picturesDir));
				options.URIResolver(new BasicURIResolver(contextPath));

				XHTMLConverter.getInstance().convert(document, out, options);
				out.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return out.toByteArray();
	}

}
