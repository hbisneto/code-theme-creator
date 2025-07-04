import { Component } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { saveAs } from 'file-saver';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MatCardModule } from '@angular/material/card';
import { MatCardHeader } from '@angular/material/card';
import { MatCardTitle } from '@angular/material/card';
import { MatCardContent } from '@angular/material/card';
import { MatCardActions } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatLabel } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';

@Component({
  selector: 'app-theme-form',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    MatCardModule,
    MatFormFieldModule,
    MatInputModule,
    MatButtonModule
  ],
  templateUrl: './theme-form.html',
  styleUrl: './theme-form.css'
})
export class ThemeForm {
  themeData = {
    name: '',
    description: '',
    publisher: '',
    colors: {
      activityBar: {
        background: '#000000',
        foreground: '#7c84ec',
        inactiveForeground: '#9d9d9d',
        activeBackground: '#000000',
        activeBorder: '#7c84ec',
        activeFocusBorder: '#7c84ec'
      },
      activityBarBadge: {
        foreground: '#FFFFFF',
        background: '#7c84ec'
      },
      tab: {
        inactiveBackground: '#000000',
        activeBackground: '#1F1F1F',
        lastPinnedBorder: '#454990'
      },
      sideBar: {
        background: '#141414'
      },
      statusBar: {
        background: '#454990',
        noFolderBackground: '#454990'
      },
      statusBarItem: {
        remoteBackground: '#7c84ec'
      },
      ports: {
        iconRunningProcessForeground: '#454990'
      },
      editorGroupHeader: {
        tabsBackground: '#000000'
      },
      titleBar: {
        activeBackground: '#454990',
        inactiveBackground: '#454990'
      },
      selection: {
        background: '#ADD6FF20'
      },
      editorHoverWidget: {
        background: '#454990'
      },
      editor: {
        hoverHighlightBackground: '#454990',
        link: {
          activeForeground: '#0597dd'
        },
        selectionBackground: '#45499080',
        selectionHighlightBackground: '#65656580',
        background: '#1F1F1F',
        border: '#000000',
        cursor: {
          foreground: '#FFFFFF'
        },
        foreground: '#FFFFFF',
        whitespace: {
          foreground: '#C4C4C4'
        },
        lineHighlightBackground: '#1F1F1F',
        lineHighlightBorder: '#FFFFFF80'
      },
      minimap: {
        selectionHighlight: '#454990'
      },
      editorLineNumber: {
        foreground: '#C4C4C4',
        activeForeground: '#454990'
      },
      editorWidget: {
        background: '#141414'
      },
      editorSuggestWidget: {
        background: '#000000',
        border: '#000000'
      },
      peekView: {
        title: {
          background: '#454990'
        },
        border: '#000000',
        result: {
          background: '#141414'
        },
        editor: {
          background: '#000000'
        }
      },
      editorIndentGuide: {
        background: '#7c84ec',
        activeBackground: '#FFFFFF'
      },
      debugToolBar: {
        background: '#454990'
      },
      focusBorder: '#FFFFFF',
      button: {
        background: '#454990'
      },
      dropdown: {
        background: '#242424'
      },
      input: {
        background: '#202020'
      },
      inputOption: {
        activeBorder: '#454990'
      },
      inputValidation: {
        infoBackground: '#454990',
        infoBorder: '#454990'
      },
      list: {
        hoverBackground: '#242424',
        activeSelectionBackground: '#242424',
        inactiveSelectionBackground: '#454990',
        dropBackground: '#454990',
        highlightForeground: '#92c353' // Adicionado
      },
      quickInputList: {
        focusBackground: '#454990'
      },
      menu: {
        background: '#1F1F1F',
        foreground: '#C2C2C2',
        selectionForeground: '#FFFFFF',
        selectionBackground: '#454545'
      },
      pickerGroup: {
        foreground: '#C4C4C4',
        border: '#454990'
      },
      badge: {
        background: '#454990'
      },
      progressBar: {
        background: '#454990'
      },
      errorForeground: '#FF0000',
      extensionButton: {
        prominentBackground: '#454990',
        prominentHoverBackground: '#454990'
      }
    }
  };

  constructor(private http: HttpClient) {}

  onSubmit() {
    this.http.post('http://localhost:5000/generate-theme', this.themeData, { responseType: 'blob' })
      .subscribe({
        next: (response: Blob) => {
          saveAs(response, `${this.themeData.name}.zip`);
        },
        error: (err: any) => {
          console.error('Error generating theme:', err);
          alert('Falha ao gerar o tema. Tente novamente.');
        }
      });
  }
}