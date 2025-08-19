/*
 * Copyright (C) 2010-2017 FBReader.ORG Limited <contact@fbreader.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA.
 */

package org.nicolae.test;

import static org.geometerplus.android.fbreader.api.FBReaderIntents.DEFAULT_PACKAGE;

import android.app.Activity;
import android.app.SearchManager;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import org.geometerplus.android.fbreader.library.LibraryActivity;

public class LocalLibrarySearchActivity extends Activity implements SearchManager.OnCancelListener, SearchManager.OnDismissListener{

	// this is the action that is forwarded to the main activity to load a book by it's ID
	public static final String LOCAL_SEARCH_RESULT_VIEW = "android.fbreader.action.LOCAL_SEARCH_RESULT_VIEW";
	// this is the action generated when tapping on a suggested book
	public static final String LOCAL_SEARCH_VIEW = "android.fbreader.action.LOCAL_SEARCH_VIEW";

//	private final BookCollectionShadow myCollection = new BookCollectionShadow();

	@Override
	public void onCreate(Bundle icicle) {
		super.onCreate(icicle);

		Intent intent = getIntent();

		if (Intent.ACTION_SEARCH.equals(intent.getAction())) {
			final String pattern = intent.getStringExtra(SearchManager.QUERY);
			if (pattern != null && pattern.length() > 0) {
				Intent newIntent = new Intent(LibraryActivity.START_SEARCH_ACTION, null, this, LibraryActivity.class);
				newIntent.setPackage(DEFAULT_PACKAGE); // starting 2023 (api 33/and 13) due to https://support.google.com/faqs/answer/10399926
				newIntent.putExtra(SearchManager.QUERY, pattern);
				startActivity(newIntent);
			}
			finish();
		} else if ( LOCAL_SEARCH_VIEW.equals(intent.getAction())) {
			Uri data = intent.getData();
			final String bookStr = intent.getExtras().getString(SearchManager.EXTRA_DATA_KEY);

			Intent newIntent = new Intent(LOCAL_SEARCH_RESULT_VIEW);
			newIntent.setPackage(DEFAULT_PACKAGE); // starting 2023 (api 33/and 13) due to https://support.google.com/faqs/answer/10399926
			newIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
			newIntent.setData( Uri.fromParts("local-search-result","book-id",bookStr));

			this.startActivity( newIntent);

			finish();
		} else {

			SearchManager searchManager = (SearchManager) this.getSystemService(Context.SEARCH_SERVICE);
			searchManager.setOnCancelListener(this);
			searchManager.setOnDismissListener(this);

			startSearch("", true, null, false);
		}
	}

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
	}

	@Override
	public boolean onSearchRequested() {
		return true;
	}

	@Override
	public void onCancel() {
		// do nothing as dismissed is called anyway...
	}

	@Override
	public void onDismiss() {
		finish();
	}
}
