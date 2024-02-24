pa rubywrapper

fu! s:NyaoStenographerSetup()
ruby << NYAOSTENOGRAPHER
require 'fileutils'
module NyaoStenographer
  def self.add
    ensure_dir
    append_abbrev_file(
      iabbrev(Ev.input("abbrev to trigger (#{visual_selection.first[0..20]}): "))
    )
    Ex.source filepath
  end

  def self.iabbrev(mapping)        = "iabbrev #{mapping} #{visual_selection.join("<CR>")}"
  def self.append_abbrev_file(str) = File.write filepath, "\n"+str, mode: 'a'
  def self.ensure_dir              = FileUtils.mkdir_p dir
  def self.filepath                = "#{dir}/nyaostenographer.vim"
  def self.dir                     = "#{ENV["HOME"]}/.vim/after/ftplugin/#{Var["&ft"]}"

  def self.visual_selection
    line_start, column_start = Ev.getpos("'<")[1..2]
    line_end,   column_end   = Ev.getpos("'>")[1..2]

    lines = Ev.getline(line_start, line_end)

    if lines.none?
      []
    else
      lines[-1] = lines[-1][0..(column_end - (Var["&selection"] == 'inclusive' ? 1 : 2))]
      lines[0]  = lines[0][column_start-1..-1]
      lines
    end
  end
end
NYAOSTENOGRAPHER
endfu

call s:NyaoStenographerSetup()

vno ,a :ruby NyaoStenographer.add<CR>
