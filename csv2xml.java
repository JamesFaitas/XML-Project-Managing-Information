import java.io.*;               // import input-output
import javax.xml.parsers.*;         // import parsers
import javax.xml.xpath.*;           // import XPath
import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import javax.xml.transform.stream.*;
import java.util.Scanner; //imports Scanner 
import java.util.NoSuchElementException;
import org.w3c.dom.*;               // import DOM

/**
DOM handler to read XML information, to create this, and to print it.

@author   jamesfaitas
@version  11/03/2017
 */
public class csv2xml{
    private static final int COMMENTS_NUMBER = 8; //fixed number of comments from the surveycomments.csv file 
    private static final int COMMENT_INDEX = 0;
    private static final int COMMENT_CONTENT = 1;
    /** Document builder */
    private static DocumentBuilder builder = null;

    /** XML document */
    private static Document document = null;

    /*----------------------------- General Methods ----------------------------*/

    /**
    Main program to call DOM creator.

    @param args         command-line name of flile
     */
    public static void main(String[] args)  {
        // The argument is used as the filename
        createDocument("survey.xml");
    }

    /**
    Set global document to create with data
    @param filename     name of the file to write
     */
    private static void createDocument(String filename) throws NoSuchElementException {
        try {
            // create a document builder
            DocumentBuilderFactory builderFactory = DocumentBuilderFactory.newInstance();
            builder = builderFactory.newDocumentBuilder();

            // new document
            document = builder.newDocument();
            
            // creates the list of questions; List as the root element and add it to the document
            Element questionList = document.createElement("questionList");
            document.appendChild(questionList);
            
            //adds a node that connects the XML to a XSLT. In this case it connects it with the xslt for the next part of the assignment 
            Node link = document.createProcessingInstruction("xml-stylesheet", "type=\"text/xsl\" href=\"xml2xhtml.xslt\"");
            document.insertBefore(link,questionList); //places the node before the questionList element

            String[] comments = getComments(COMMENT_CONTENT);
            String[] commentIndex = getComments(COMMENT_INDEX);
            int count=0;
            
            File input = new File("surveydata.csv");
            if(!input.exists() || !input.canRead() || input.isDirectory()){ //handles error if input file doenst exist/can't be read or is a directory
                    System.out.println("The survey data csv file doesn't exist.\nThe program will now terminate."); //output message
                    System.exit(1); //program is termimated
            }
            Scanner scan = new Scanner(input);
            scan.nextLine(); //skips first line containing headers 

            while(scan.hasNext()) {
                String line = scan.nextLine(); //scans each line
                //this regex is used to remove the commas from the string, excluding the ones that are insde double quotation
                String[] answers = line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");   

                //element creation
                Element question = document.createElement("question");
                Element query = document.createElement("query");
                Element answer = document.createElement("answer");
                Element yes = document.createElement("yes");
                Element no = document.createElement("no");
                Element sit = document.createElement("sit");
                Element stand = document.createElement("stand");
                Element blank = document.createElement("blank");
                Element optional = document.createElement("optional");
                Element comment = document.createElement("comment");
                //Element id = document.createElement("id");
                Element content = document.createElement("content");
                Element newComment = document.createElement("comment");
                Element newContent = document.createElement("comment");
                //saves the data appropriately to the elements
                query.appendChild(document.createTextNode(answers[0]));
                //checks if there is a query comment element
                if(answers[1].matches("[a-z]")){ //if content of answers is a character; indicates there's a comment
                    comment.setAttribute("id", commentIndex[count]); //set id attribute to the comment element 
                    comment.appendChild(content); //append the content child element to the comment 
                    content.appendChild(document.createTextNode(comments[count])); //gets the data for the content 
                    count++; //increments counter 
                }
                yes.appendChild(document.createTextNode(answers[2]));
                no.appendChild(document.createTextNode(answers[4]));
                //checks if there's a comment about the no element 
                if(answers[5].matches("[a-z]")){ //if it matches to a character then repeats simillar process to the one above 
                    newComment.setAttribute("id", commentIndex[count]);
                    newComment.appendChild(newContent);
                    newContent.appendChild(document.createTextNode(comments[count]));
                    count++;
                }
                sit.appendChild(document.createTextNode(answers[6]));
                stand.appendChild(document.createTextNode(answers[8]));
                blank.appendChild(document.createTextNode(answers[10]));

                if(answers.length == 13) //checks if there's an optional element 
                    optional.appendChild(document.createTextNode(answers[12]));

                //appends the child elements to the appropriate element
                append(answer,yes);
                append(answer,no);
                append(answer,stand);
                append(answer,sit);
                append(answer,blank);
                append(answer,optional);

                question.appendChild(query);
                question.appendChild(answer);
                question.appendChild(comment);

                question.appendChild(newComment);
                if(!newComment.hasChildNodes()) //if there's no second comment element then it removes the node from the question root node
                    question.removeChild(newComment);
                if(!comment.hasChildNodes())//if there's no first comment element then it removes the node from the question root node
                    question.removeChild(comment);

                questionList.appendChild(question);
            }
            //Outputs appropriate message for when xml file has been successfully created
            System.out.println("The xml file: survey.xml has been created successfully!");

            // This allows saving the DOM as a file with indendation
            File file = new File(filename);
            Source source = new DOMSource(document);
            Result result = new StreamResult(file);
            Transformer transf = TransformerFactory.newInstance().newTransformer();
            
            transf.setOutputProperty(OutputKeys.INDENT, "yes"); //makes it look normal 
            transf.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
            transf.transform(source, result);
        }
        catch (Exception exception) {
            System.err.println("could not create document " + exception); //prints out error message 
        }
    }

    /**
    Check if a node is empty and if not appends it as a child node to the root node
    @param root root node
    @param child child node that is appended to the root node
     */
    public static void append(Element root, Element child){
        if(!child.getTextContent().isEmpty()) //checks if node is empty
            root.appendChild(child); //if not, appends it to the root node 
    }

    /**
    Reads the surveycomments.csv file and copies its content to a String array
    @param choice choose whether you want the index of the comments that's located inside the file, or the content of the content
    Comment index would be in position 0
    Comment content would be in position 1
     */
    public static String[] getComments(int choice) throws FileNotFoundException{
        File commentsInput = new File("surveycomments.csv");
        if(!commentsInput.exists() || !commentsInput.canRead() || commentsInput.isDirectory()){ //handles error if input file doenst exist/can't be read or is a directory
                    System.out.println("The comments csv file doesn't exist.\nThe program will now terminate."); //output message
                    System.exit(1); //program is termimated
            }
        Scanner scan = new Scanner(commentsInput); //reads the csv file 
        scan.nextLine(); //skips the first line where the headers are stored
        String[] commentArray = new String[COMMENTS_NUMBER]; //creates and array of eight strings, since that's the total amount of comments
        int index =0; //index for the commentArray 
        while(scan.hasNext()){
            String line = scan.nextLine(); //reads each line
            String[] surveyComments = line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)"); //uses regex to split it; regex is explained above
            commentArray[index] = surveyComments[choice]; //assigns content of surveycomments array
            index++; //increments the index to itirate throuhg the array 
        }
        return commentArray;
    }
}
