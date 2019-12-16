StudyRepoTemplate
=================

An OHDSI study repository is expected to have a README.md file where the header conforms to a standard. A template README file is provided here:

**[README file template](templateREADME.md)**

When initiating a repository, please copy this file, rename it to 'README.md', and fill in the fields as appropriate.

The information in the repository README file will be used to update the [list of OHDSI research studies](https://www.ohdsi.org/network-research-studies/), so it is important to fill in the template accurately, and keep it up-to-date.

## Elements in the README template

| Element | Description |
| ------- | ----------- |
| [Study title]      | A meaningful title of the research project.            
| Study status badge | A badge indicating the stuy status. See [below](#study-status) for valid options. |
| Analytics use case | One or more analytics use cases included in the study (in a comma-separated list). See [below](#analytics-use-cases) for valid options. |
| Study type | The type of study. See [below](#study-types) for valid options. |
| Tags | Zero, one, or more additional keywords that can be used to filter the list of studies. The list of tags is not restricted, but be conservative in making up new tags. For example: `EHDEN` to identify studies that are part of the [EHDEN project](https://www.ehden.eu/). |
| Study lead | The name of the study lead. Contact details are not required, since the lead is assumed to monitor the repo issue tracker and can therefore be reached that way. |
| Study start date | When did work on the study commence? This date typically indicates when development of the protocol was initiated. |
| Study end date | When was the study completed? This typicaly indicates when the analyses are completed and the results have been collected. | 
| Protocol | A hyperlink to the protocol. The protocol is expected to be a document in the study repository itself. | 
| Publications | Zero, one or more hyperlinks to papers produced as part of the study (comma-separated). | 
| Results explorer | A hyperlink to a web app (e.g. a Shiny app) where the results of the study can be explored. |

### Study Status

Choose one of the following options:

| Badge             | Description                          | Markdown code |
| ----------------- | ------------------------------------ | ------------- |
| <img src="https://img.shields.io/badge/Study%20Status-Repo%20Created-lightgray.svg" alt="Study Status: Repo Created"> | The study repository has just been created. Work has not yet commenced. | <button onclick="copyToClipboard('<img src=&quot;Study%20Status-Repo%20Created-lightgray.svg&quot; alt=&quot;Study Status: Repo Created&quot;>')">Copy to clipboard</button> |
| <img src="https://img.shields.io/badge/Study%20Status-Started-blue.svg" alt="Study Status: Started"> | A first commit was made (to something else than the README file). Work has commenced. | <button onclick="copyToClipboard('<img src=&quot;https://img.shields.io/badge/Study%20Status-Started-blue.svg&quot; alt=&quot;Study Status: Started&quot;>')">Copy to clipboard</button> |
| <img src="https://img.shields.io/badge/Study%20Status-Design%20Finalized-brightgreen.svg" alt="Study Status: Design Finalized"> | The protocol and study code have been finalized. | <button onclick="copyToClipboard('<img src=&quot;https://img.shields.io/badge/Study%20Status-Design%20Finalized-brightgreen.svg&quot; alt=&quot;Study Status: Design Finalized&quot;>')">Copy to clipboard</button> |
| <img src="https://img.shields.io/badge/Study%20Status-Results%20Available-yellow.svg" alt="Study Status: Results Avaialable"> | The study results are publicly available, for example in a paper or results explorer app. | <button onclick="copyToClipboard('<img src=&quot;https://img.shields.io/badge/Study%20Status-Results%20Available-yellow.svg&quot; alt=&quot;Study Status: Results Avaialable&quot;>')">Copy to clipboard</button> |
| <img src="https://img.shields.io/badge/Study%20Status-Complete-orange.svg" alt="Study Status: Complete"> | The study is complete, no further dissemination planned. | <button onclick="copyToClipboard('<img src=&quot;https://img.shields.io/badge/Study%20Status-Complete-orange.svg&quot; alt=&quot;Study Status: Completed&quot;>')">Copy to clipboard</button> |
| <img src="https://img.shields.io/badge/Study%20Status-Suspended-red.svg" alt="Study Status: Suspended"> | The study has been suspended, and may or may not be continued at a later point in time. | <button onclick="copyToClipboard('<img src=&quot;https://img.shields.io/badge/Study%20Status-Suspended-red.svg&quot; alt=&quot;Study Status: Suspended&quot;>')">Copy to clipboard</button> |

Copy the relevant markdown code to your clipboard, and past it in your READM file, just below the study title.

### Analytics Use Cases

Choose options from: 

- `Characterization`
- `Population-Level Estimation`, or
- `Patient-Level Prediction` 

See [the Data Aanlytics Use Cases chapter](https://ohdsi.github.io/TheBookOfOhdsi/DataAnalyticsUseCases.html) for more details.

### Study types

Can be either:

- `Methods Research` if the study explores a methodological question, for example an evaluation of various propensity score approaches. 
- `Clinical Application` if the study aims to answer a clinically releveant question, for example 'Does drug A cause outcome B?'.

<script>
function copyToClipboard(value) {
  element = $('<textarea>').appendTo('body').val(value).select();
  document.execCommand('copy');
  element.remove();
}
</script>
