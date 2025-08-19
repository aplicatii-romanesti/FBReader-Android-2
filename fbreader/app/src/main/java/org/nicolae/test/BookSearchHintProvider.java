package org.nicolae.test;

//import org.geometerplus.android.fbreader.library.SQLiteBooksDatabase;
import org.geometerplus.android.fbreader.libraryService.SQLiteBooksDatabase;
//import org.geometerplus.fbreader.library.BooksDatabase;
import org.geometerplus.fbreader.book.BooksDatabase;

import android.app.SearchManager;
import android.content.ContentProvider;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.UriMatcher;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteQueryBuilder;
import android.net.Uri;
import android.provider.BaseColumns;

public class BookSearchHintProvider extends ContentProvider {

	String TAG = "BookSearchHintProvider";

	//private BooksDatabase myDatabaseInit = SQLiteBooksDatabase.Instance();//aplicatii.romanesti
	private SQLiteDatabase myDatabase = null;

	public static String AUTHORITY = "org.nicolae.test.BookSearchHintProvider";
	public static final Uri CONTENT_URI = Uri.parse("content://" + AUTHORITY
			+ "/dictionary");

	// MIME types used for searching words or looking up a single definition
	public static final String WORDS_MIME_TYPE = ContentResolver.CURSOR_DIR_BASE_TYPE
			+ "/vnd.nicolae.test";
	public static final String DEFINITION_MIME_TYPE = ContentResolver.CURSOR_ITEM_BASE_TYPE
			+ "/vnd.nicolae.test";

	// UriMatcher stuff
	private static final int SEARCH_WORDS = 0;
	private static final int GET_WORD = 1;
	private static final int SEARCH_SUGGEST = 2;
	private static final int REFRESH_SHORTCUT = 3;
	private static final UriMatcher sURIMatcher = buildUriMatcher();

	/**
	 * Builds up a UriMatcher for search suggestion and shortcut refresh
	 * queries.
	 */
	private static UriMatcher buildUriMatcher() {
		UriMatcher matcher = new UriMatcher(UriMatcher.NO_MATCH);
		// to get definitions...
		matcher.addURI(AUTHORITY, "dictionary", SEARCH_WORDS);
		matcher.addURI(AUTHORITY, "dictionary/#", GET_WORD);
		// to get suggestions...
		matcher.addURI(AUTHORITY, SearchManager.SUGGEST_URI_PATH_QUERY,
				SEARCH_SUGGEST);
		matcher.addURI(AUTHORITY, SearchManager.SUGGEST_URI_PATH_QUERY + "/*",
				SEARCH_SUGGEST);

		/*
		 * The following are unused in this implementation, but if we include
		 * {@link SearchManager#SUGGEST_COLUMN_SHORTCUT_ID} as a column in our
		 * suggestions table, we could expect to receive refresh queries when a
		 * shortcutted suggestion is displayed in Quick Search Box, in which
		 * case, the following Uris would be provided and we would return a
		 * cursor with a single item representing the refreshed suggestion data.
		 */
		matcher.addURI(AUTHORITY, SearchManager.SUGGEST_URI_PATH_SHORTCUT,
				REFRESH_SHORTCUT);
		matcher.addURI(AUTHORITY, SearchManager.SUGGEST_URI_PATH_SHORTCUT
				+ "/*", REFRESH_SHORTCUT);
		return matcher;
	}

	@Override
	public int delete(Uri uri, String selection, String[] selectionArgs) {
		throw new UnsupportedOperationException();
	}

	@Override
	public String getType(Uri uri) {
		switch (sURIMatcher.match(uri)) {
		case SEARCH_WORDS:
			return WORDS_MIME_TYPE;
		case GET_WORD:
			return DEFINITION_MIME_TYPE;
		case SEARCH_SUGGEST:
			return SearchManager.SUGGEST_MIME_TYPE;
		case REFRESH_SHORTCUT:
			return SearchManager.SHORTCUT_MIME_TYPE;
		default:
			throw new IllegalArgumentException("Unknown URL " + uri);
		}
	}

	@Override
	public Uri insert(Uri uri, ContentValues values) {
		throw new UnsupportedOperationException();
	}

	@Override
	public boolean onCreate() {
		return true;
	}

	private static final String BOOK_SEARCH_HINTS = "BookSearchHintsV2";

	// the column names in this view are important
	// they match SearchManager.SUGGEST_* constants
	private static final String BOOK_SEARCH_HINTS_CREATE_SQL = ""
			+ "create view " + BOOK_SEARCH_HINTS + " as            "
			+ "select " + "	b.book_id as _id, "
			+ "	b.title as  suggest_text_1, "
			+ "	f2.name || '/' || f1.name as suggest_text_2, "
			+ "	b.book_id as suggest_intent_extra_data "
			+ "from books b, files f1, files f2 "
			+ "where b.file_id = f1.file_id and f1.parent_id=f2.file_id ";

	private synchronized void connectToDatabase() {
		
//		if (myDatabaseInit == null) {//aplicatii.romanesti
//			myDatabaseInit = new SQLiteBooksDatabase(getContext(), "LIBRARY");//aplicatii.romanesti
//		}
		
		if (myDatabase == null) {

			myDatabase = getContext().openOrCreateDatabase("books.db",
					Context.MODE_PRIVATE, null);
			try {
				Cursor res = myDatabase.rawQuery("select count(*) from "
						+ BOOK_SEARCH_HINTS, null);
				res.close();
			} catch (Exception e) {
				myDatabase.execSQL(BOOK_SEARCH_HINTS_CREATE_SQL);
			}
		}
	}

	public synchronized void resetDbConnection(){
		if ( null != myDatabase){
			myDatabase.close();
			myDatabase = null;
		}
	}

	private Cursor query(String selection, String[] selectionArgs,
			String[] columns) {

		if (myDatabase == null) {
			connectToDatabase();
		}

		SQLiteQueryBuilder builder = new SQLiteQueryBuilder();
		builder.setTables(BOOK_SEARCH_HINTS);

		if (selectionArgs[0] != null) {
			selectionArgs[0] = "%" + selectionArgs[0].toUpperCase() + "%";
		}

		Cursor cursor = builder.query(myDatabase, columns, selection,
				selectionArgs, null, null, null);

		if (!cursor.moveToFirst()) {
			cursor.close();
			return null;
		}
		return cursor;
	}

	@Override
	public Cursor query(Uri uri, String[] projection, String selection,
			String[] selectionArgs, String sortOrder) {
		Cursor mk = query(selection, selectionArgs, new String[] {
				BaseColumns._ID, SearchManager.SUGGEST_COLUMN_TEXT_1,
				SearchManager.SUGGEST_COLUMN_TEXT_2,
				SearchManager.SUGGEST_COLUMN_INTENT_EXTRA_DATA });
		switch (sURIMatcher.match(uri)) {
		case SEARCH_SUGGEST:
			if (selectionArgs == null) {
				throw new IllegalArgumentException(
						"selectionArgs must be provided for the Uri: " + uri);
			}
			return mk;
		case SEARCH_WORDS:
			if (selectionArgs == null) {
				throw new IllegalArgumentException(
						"selectionArgs must be provided for the Uri: " + uri);
			}
			return mk;
		case GET_WORD:
			return mk;
		case REFRESH_SHORTCUT:
			return mk;
		default:
			throw new IllegalArgumentException("Unknown Uri: " + uri);
		}
	}

	@Override
	public int update(Uri uri, ContentValues values, String selection,
			String[] selectionArgs) {
		throw new UnsupportedOperationException();
	}

}
