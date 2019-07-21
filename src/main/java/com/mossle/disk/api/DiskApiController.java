package com.mossle.disk.api;

import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.List;

import javax.annotation.Resource;

import javax.servlet.ServletContext;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import com.mossle.api.auth.CurrentUserHolder;
import com.mossle.api.tenant.TenantHolder;

import com.mossle.client.store.StoreClient;
import com.mossle.core.util.IoUtils;
import com.mossle.core.util.ServletUtils;
import com.mossle.disk.persistence.domain.DiskInfo;
import com.mossle.disk.persistence.manager.DiskInfoManager;
import com.mossle.disk.service.DiskService;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.hwpf.converter.*;
import org.apache.poi.hwpf.usermodel.*;

import org.apache.poi.xwpf.usermodel.*;

import org.apache.poi.poifs.filesystem.POIFSFileSystem;

import com.mossle.disk.office2html.*;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.w3c.dom.Document;

import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.commons.collections.MapUtils;

//import fr.opensagres.poi.xwpf.converter.pdf.PdfOptions;
//import fr.opensagres.poi.xwpf.converter.pdf.PdfConverter;

import org.apache.poi.hssf.converter.ExcelToHtmlConverter;
import org.apache.poi.hssf.usermodel.*;

import org.apache.poi.xwpf.converter.pdf.PdfConverter;
import org.apache.poi.xwpf.converter.pdf.PdfOptions;


@RestController
@RequestMapping("disk/api")
public class DiskApiController {
	private DiskInfoManager diskInfoManager;
	private StoreClient storeClient;
	private TenantHolder tenantHolder;
	private CurrentUserHolder currentUserHolder;
	private DiskService diskService;
	private ServletContext servletContext;

	@RequestMapping(value = "{username}")
	public void diskstore(@RequestParam("id") Long id,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String userId = currentUserHolder.getUserId();
        String tenantId = tenantHolder.getTenantId();
        DiskInfo diskInfo = diskInfoManager.get(id);
        InputStream is = null;

        try {
        	is = storeClient
			            .getStore("disk/user/" + userId, diskInfo.getRef(),
			                    tenantId).getDataSource().getInputStream();
        	
        	//String filePath = request.getSession().getServletContext().getRealPath("/");//request.getServletContext().getRealPath("/");
			
        	String strType = diskInfo.getType(); 
        	
        	if(strType.equals("doc") || strType.equals("docx")) {
        		String contextpath = request.getContextPath() + "/cdn/images/" + userId;
    			String realPath = servletContext.getRealPath("/") + "/cdn/images/" + userId;

            	byte[] byteArray = POIWordToHtml.wordToHtml(is, diskInfo.getType(), realPath, contextpath);
            	OutputStream os = response.getOutputStream();

            	try {
            	   os.write(byteArray , 0, byteArray.length);
            	} catch (Exception excp) {
            	   //handle error
            	} finally {
            	    os.close();
            	}
        	} else if(strType.equals("xls") || strType.equals("xlsx")) {
        		String html = POIExcelToHtml.excelToHtml(is, true);
        		response.setContentType( "text/html;charset=UTF-8" );
                PrintWriter out = response.getWriter();

                try {
                	out.println("<html><body>");
                	out.println(html);
                	out.println("</body></html>");
                } finally {            
                    out.close();
                }
        	} else if(strType.equals("csv")) {
        		DataInputStream dis = new DataInputStream(is);
        		
        		response.setContentType( "text/html;charset=UTF-8" );
                PrintWriter out = response.getWriter();
                
                try {
	                out.println("<html><body><table>");
	                
	                String line; 
	                int count=0; 
	        		
	        		int i=0; 
	        		while ((line = dis.readLine()) != null) {
	        			String ar[] = line.split(",");
	        			out.println("<tr>");
	        			for(int j=0;j<ar.length;j++) {
	        				if(i != 0) 
	        					out.print("<td> " + ar[j] + "</td> ");
	        				else
	        					out.print("<td> <b>" + ar[j] + "</b> </td>");
	        			}
	        			i++;
	        			out.println("<tr>");
	        		}
	        		
	        		out.println("</table></body></html>");
                } finally {            
                    out.close();
                }	 
        	} else {
        		IOUtils.copy(is, response.getOutputStream());
        	}
        	
        	
        	/*
            OutputStream os = response.getOutputStream();
            
            try {
    			XWPFDocument document = new XWPFDocument(is);
    	    	PdfOptions options = PdfOptions.create();
    	    	//OutputStream out = new FileOutputStream(new File(pdfPath));
    	    	PdfConverter.getInstance().convert(document, os, options);
    		
    	    	document.close();
    	    	os.close();
    		} catch (FileNotFoundException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		} catch (IOException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		}
            
            /*
            response.setContentType( "text/plain;charset=UTF-8" );
            response.setHeader( "Content-Disposition", "attachment;filename=MyTextFile.txt" );
            PrintWriter out = response.getWriter();

            try {

                out.println( "Some content..." );
                out.println( "Some more..." );

            } finally {            
                out.close();
            }
            */
            
            //response.setContentType("image/png");

            //if(diskInfo.getType() == "txt")
            //String text = IOUtils.toString(is, "utf-8");
            
            //response.setContentType("text/html;charset=UTF-8");
            //IoUtils.copyStream(is, response.getOutputStream());
        } catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
            if (is != null) {
                is.close();
            }
        }
    }

	public void test(){

		try {
			FileInputStream in = new FileInputStream(new File("2.xls"));
			POIFSFileSystem fs = new POIFSFileSystem(in);
			HSSFWorkbook wk = new HSSFWorkbook(fs);
			HSSFSheet sheet = wk.getSheetAt(0);
			
			for (Row row : sheet) {
				//打印行索引
				//System.out.println(row.getRowNum());
				//遍历单元格对象
					//表头不要打印
				for (Cell cell : row) {
					//获取每个单元格的类型
					int cellType = cell.getCellType();
					if(cellType == cell.CELL_TYPE_BLANK){
						//System.out.println("空格类型");
						System.out.print("\t");
					}
					if(cellType == cell.CELL_TYPE_NUMERIC){
						//System.out.println("数字类型");
						System.out.print(cell.getNumericCellValue()+"\t");
					}
					if(cellType == cell.CELL_TYPE_STRING){
						//System.out.println("字符串类型");
						System.out.print(cell.getStringCellValue()+"\t");
					}
				}
				//换行
				System.out.println();
			}
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
	
    public void excelConverterToPdf() {
        String file = "./1.xlsx";
        
        try{
	        InputStream input=new FileInputStream(file);
	        HSSFWorkbook excelBook=new HSSFWorkbook(input);
	        ExcelToHtmlConverter excelToHtmlConverter = new ExcelToHtmlConverter (DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument() );
	        excelToHtmlConverter.processWorkbook(excelBook);
	        List pics = excelBook.getAllPictures();
	        if (pics != null) {
	            for (int i = 0; i < pics.size(); i++) {
	                Picture pic = (Picture) pics.get (i);
	                try {
	                    pic.writeImageContent (new FileOutputStream (pic.suggestFullFileName() ) );
	                } catch (FileNotFoundException e) {
	                    e.printStackTrace();
	                }
	            }
	        }
	        Document htmlDocument =excelToHtmlConverter.getDocument();
	        ByteArrayOutputStream outStream = new ByteArrayOutputStream();
	        DOMSource domSource = new DOMSource (htmlDocument);
	        StreamResult streamResult = new StreamResult (outStream);
	        TransformerFactory tf = TransformerFactory.newInstance();
	        Transformer serializer = tf.newTransformer();
	        serializer.setOutputProperty (OutputKeys.ENCODING, "utf-8");
	        serializer.setOutputProperty (OutputKeys.INDENT, "yes");
	        serializer.setOutputProperty (OutputKeys.METHOD, "html");
	        serializer.transform (domSource, streamResult);
	        outStream.close();
	    
	        String content = new String (outStream.toByteArray() );
	    
	        FileUtils.writeStringToFile(new File ("exportExcel.html"), content, "utf-8");
        } catch(Exception e) {
        	
        }
}
    
    public void wordConverterToPdf() {
    	String docPath = "./Linux.docx";
    	String pdfPath = "./Linux.pdf";
    	
		try {
			InputStream in = new FileInputStream(new File(docPath));
			XWPFDocument document = new XWPFDocument(in);
	    	PdfOptions options = PdfOptions.create();
	    	OutputStream out = new FileOutputStream(new File(pdfPath));
	    	PdfConverter.getInstance().convert(document, out, options);
		
	    	document.close();
	    	out.close();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    
/*    public static void wordConverterToPdf(InputStream source, OutputStream target, 
            PdfOptions options,
            Map<String, String> params) throws Exception {
         XWPFDocument doc = new XWPFDocument(source);
         paragraphReplace(doc.getParagraphs(), params);
         for (XWPFTable table : doc.getTables()) {
           for (XWPFTableRow row : table.getRows()) {
               for (XWPFTableCell cell : row.getTableCells()) {
                   paragraphReplace(cell.getParagraphs(), params);
               }
           }
       }
       PdfConverter.getInstance().convert(doc, target, options);
    }
    private static void paragraphReplace(List<XWPFParagraph> paragraphs, Map<String, String> params) {
        if (MapUtils.isNotEmpty(params)) {
            for (XWPFParagraph p : paragraphs){
                for (XWPFRun r : p.getRuns()){
                    String content = r.getText(r.getTextPosition());
                    logger.info(content);
                    if(StringUtils.isNotEmpty(content) && params.containsKey(content)) {
                        r.setText(params.get(content), 0);
                    }
                }
            }
        }
    }
*/

	// ~ ======================================================================
	// ~ ======================================================================
    @Resource
    public void setDiskInfoManager(DiskInfoManager diskInfoManager) {
        this.diskInfoManager = diskInfoManager;
    }

    
    @Resource
    public void setCurrentUserHolder(CurrentUserHolder currentUserHolder) {
        this.currentUserHolder = currentUserHolder;
    }

    @Resource
    public void setStoreClient(StoreClient storeClient) {
        this.storeClient = storeClient;
    }

    @Resource
    public void setDiskService(DiskService diskService) {
        this.diskService = diskService;
    }

    @Resource
    public void setTenantHolder(TenantHolder tenantHolder) {
        this.tenantHolder = tenantHolder;
	}
	
	@Resource
    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
    }
}
