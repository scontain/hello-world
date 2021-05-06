import java.net.URL;
import java.util.Scanner;
import java.io.File;
class HelloWorld {
    public static void main(String[] args) throws Exception {
        System.out.println("Hello World Java!");
        
        byte[] bytes = readFileBytesFromUrl("https://example.com/");
        System.out.println(new String(bytes));

        Scanner input = new Scanner(new File("/etc/hosts"));
        while (input.hasNextLine())
        {
           System.out.println(input.nextLine());
        }
        input = new Scanner(new File("/etc/resolv.conf"));
        while (input.hasNextLine())
        {
           System.out.println(input.nextLine());
        }
    }


    public static byte[] readFileBytesFromUrl(String url) {
        try {
            return new URL(url).openStream().readAllBytes();
        } catch (Exception e) {
            System.out.println(e);
            return new byte[0];
        }
    }
}