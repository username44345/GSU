package Assignments;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URI;
import java.util.HashMap;
import java.util.Map;
import java.util.StringTokenizer;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class PageRankIncomplete {

  public static class PowerIterationMapper
       extends Mapper<Object, Text, IntWritable, DoubleWritable>{
	  
	// The PageRank Values of all the nodes; the PageRank vector
	private Map<Integer, Double> vPRValues = new HashMap<Integer, Double>();
	// The variables for this node and its out-neighbor nodes
    private Integer nThisNodeIndex = 0;
    private IntWritable nNeighborNodeIndex = new IntWritable();
    private Double dThisNodePRValue = 0.0;
    private Integer nThisNodeOutDegree = 0;
    private DoubleWritable dThisNodePassingValue = new DoubleWritable();
    
    @Override
    protected void setup
    (
            Mapper<Object, Text, IntWritable, DoubleWritable>.Context context)
            throws IOException, InterruptedException {
        if (context.getCacheFiles() != null
                && context.getCacheFiles().length > 0) {
        	URI[] cacheFiles = context.getCacheFiles();
        	String sCacheFileName = cacheFiles[0].toString();
        	FileSystem aFileSystem = FileSystem.get(context.getConfiguration());
        	Path aPath = new Path(sCacheFileName);
            BufferedReader br = new BufferedReader(new InputStreamReader(aFileSystem.open(aPath)));
        	String line;
        	System.out.println("PR Values");
        	// Read the PageRank values of all nodes in this iteration.
        	while ((line = br.readLine()) != null) {
        		// process the line.
        		Integer nOneNodeIndex = 0;
        		Double  dOneNodePRValue = 0.0;
        		StringTokenizer itr = new StringTokenizer(line);
        		nOneNodeIndex = Integer.parseInt(itr.nextToken());
        		dOneNodePRValue = Double.parseDouble(itr.nextToken());
        		vPRValues.put(nOneNodeIndex, dOneNodePRValue);
        		System.out.println(nOneNodeIndex + " " + dOneNodePRValue);
        	}
        }
        super.setup(context);
    }
    
    public void map(Object key, Text value, Context context
                    ) throws IOException, InterruptedException {
    	// You need to complete this function.
		
    }
  }

  public static class PowerIterationReducer
       extends Reducer<IntWritable,DoubleWritable,IntWritable,DoubleWritable> {
    private DoubleWritable dNewPRValue = new DoubleWritable();

	// The PageRank Values of all the nodes; the PageRank vector
	private Map<Integer, Double> vPRValues = new HashMap<Integer, Double>();
	private Integer nNumOfNodes = 0;
	
    @Override
    protected void setup
    (
    		Reducer<IntWritable,DoubleWritable,IntWritable,DoubleWritable>.Context context)
            throws IOException, InterruptedException {
        if (context.getCacheFiles() != null
                && context.getCacheFiles().length > 0) {
        	URI[] cacheFiles = context.getCacheFiles();
        	String sCacheFileName = cacheFiles[0].toString();
        	FileSystem aFileSystem = FileSystem.get(context.getConfiguration());
        	Path aPath = new Path(sCacheFileName);
        	BufferedReader br = new BufferedReader(new InputStreamReader(aFileSystem.open(aPath)));
        	String line;
        	while ((line = br.readLine()) != null) {
        		// process the line.
        		Integer nOneNodeIndex = 0;
        		Double  dOneNodePRValue = 0.0;
        		StringTokenizer itr = new StringTokenizer(line);
        		nOneNodeIndex = Integer.parseInt(itr.nextToken());
        		dOneNodePRValue = Double.parseDouble(itr.nextToken());
        		vPRValues.put(nOneNodeIndex, dOneNodePRValue);
        	}
        	nNumOfNodes = vPRValues.size();
        }
        super.setup(context);
    }

    public void reduce(IntWritable key, Iterable<DoubleWritable> values,
                       Context context
                       ) throws IOException, InterruptedException 
    {
      // You need to complete this function.
      
    }
  }

  public static void main(String[] args) throws Exception {
	  // args[0] the initial PageRank values
	  String sInputPathForOneIteration = args[0];
	  // args[1] the input file containing the adjacency list of the graph
	  String sInputAdjacencyList = args[1];
	  // args[2] Output path
	  String sExpPath = args[2];
	  String sOutputFilenameForPreviousIteration = "";
	  // args[3] number of iterations
	  Integer nNumOfTotalIterations = Integer.parseInt(args[3]);
	  for (Integer nIdxOfIteration = 0; 
		 nIdxOfIteration < nNumOfTotalIterations; nIdxOfIteration++){
		  System.out.println("Iteration: " + nIdxOfIteration);
		  Configuration conf = new Configuration();
		  Job job = Job.getInstance(conf, "Power Iteration Method");
		  job.setJarByClass(PageRankIncomplete.class);
		  job.setMapperClass(PowerIterationMapper.class);
		  job.setReducerClass(PowerIterationReducer.class);
		  job.setOutputKeyClass(IntWritable.class);
		  job.setOutputValueClass(DoubleWritable.class);
		  if (nIdxOfIteration > 0) { // In the Iteration 2, 3, 4, ..., 
		  // the output of the previous iteration => the input of this iteration
			  sInputPathForOneIteration = sOutputFilenameForPreviousIteration;
		  }
		  job.addCacheFile(new Path(sInputPathForOneIteration).toUri());
		  FileInputFormat.addInputPath(job, new Path(sInputAdjacencyList));
		  // Change the output directory
		  String sOutputPath = sExpPath + "/Iteration" + 
				  				nIdxOfIteration.toString() + "/";
		  String sOutputFilename = sOutputPath + "part-r-00000";
		  sOutputFilenameForPreviousIteration = sOutputFilename;
		  FileOutputFormat.setOutputPath(job, new Path(sOutputPath));
		  if (nIdxOfIteration < nNumOfTotalIterations - 1) {
			  job.waitForCompletion(true);
		  } else {
			  System.exit(job.waitForCompletion(true) ? 0 : 1);
		  }
	  }
  }
}