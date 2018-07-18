package iris.web.common.util;

import java.io.IOException;
import org.apache.pdfbox.exceptions.COSVisitorException;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.edit.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDFont;
import org.apache.pdfbox.pdmodel.font.PDType1Font;

/**
 * DESC : http://pdfbox.apache.org/ site cookbook을 커스텀하였음을 밝힘
 * 
 * @Company
 * @author hanjoong.cho
 * @Date 2013. 7. 6. 오전 10:10:59
 */

public class DocumentCreation {

	public static void main(String[] args) {
		createPDF();
	}

	public static boolean createPDF() {

		boolean result = true;
		PDDocument document = null;

		try {
			document = new PDDocument();
		} catch (Exception e) {
			result = false;
			System.out.println("DocumentCreatioin-createPDF ERROR : "+ e.getMessage());
		}

		PDPage blankPage = new PDPage();

		document.addPage(blankPage);
		PDFont font = PDType1Font.TIMES_ITALIC;
		PDPageContentStream contentStream = null;

		try {
			contentStream = new PDPageContentStream(document, blankPage);
			contentStream.setFont(font, 50);
			contentStream.beginText();
			contentStream.moveTextPositionByAmount(0, 100);
			contentStream.drawString("A18!!!");
			contentStream.endText();

		} catch (IOException e) {
			System.out.println("DocumentCreatioin-createPDF ERROR : "+ e.getMessage());
		} finally {
			try {
				contentStream.close();
			} catch (IOException e) {
				System.out.println("DocumentCreatioin-createPDF ERROR : "+ e.getMessage());
			}
		}

		try {
			document.save("D:/createPDF.pdf");
		} catch (COSVisitorException e) {
			result = false;
			System.out.println("DocumentCreatioin-createPDF ERROR : "+ e.getMessage());
		} catch (IOException e) {
			result = false;
			System.out.println("DocumentCreatioin-createPDF ERROR : "+ e.getMessage());
		}

		try {
			document.close();
		} catch (IOException e) {
			result = false;
			System.out.println("DocumentCreatioin-createPDF ERROR : "+ e.getMessage());
		}

		return result;

	}

}
